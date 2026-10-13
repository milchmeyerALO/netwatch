
<?php
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

$dbHost = getenv('DB_HOST') ?: 'db';
$dbPort = (int) (getenv('DB_PORT') ?: 3306);
$dbName = getenv('DB_NAME') ?: 'netwatchdb';
$dbUser = getenv('DB_USER') ?: '';
$dbPassword = getenv('DB_PASSWORD') ?: '';

$error = null;
$systems = [];
$history = [];
$totalSystems = 0;
$onlineSystems = 0;
$offlineSystems = 0;

try {
    $db = new mysqli(
        $dbHost,
        $dbUser,
        $dbPassword,
        $dbName,
        $dbPort
    );
    $db->set_charset('utf8mb4');

    // Letzte Prüfung jedes Systems ermitteln.
    $result = $db->query("
        SELECT
            s.system_id,
            s.system_name,
            c.check_date,
            st.status_name,
            c.response_time
        FROM `system` AS s
        LEFT JOIN checks AS c
            ON c.check_id = (
                SELECT MAX(c2.check_id)
                FROM checks AS c2
                WHERE c2.system_id = s.system_id
            )
        LEFT JOIN status AS st
            ON st.status_id = c.status_id
        ORDER BY s.system_name
    ");

    $systems = $result->fetch_all(MYSQLI_ASSOC);
    $totalSystems = count($systems);

    foreach ($systems as $system) {
        if ($system['status_name'] === 'ONLINE') {
            $onlineSystems++;
        } elseif ($system['status_name'] === 'OFFLINE') {
            $offlineSystems++;
        }
    }

    // Die letzten zehn Prüfungen aller Systeme.
    $result = $db->query("
        SELECT
            s.system_name,
            c.check_date,
            st.status_name,
            c.response_time
        FROM checks AS c
        JOIN `system` AS s
            ON s.system_id = c.system_id
        JOIN status AS st
            ON st.status_id = c.status_id
        ORDER BY c.check_id DESC
        LIMIT 10
    ");

    $history = $result->fetch_all(MYSQLI_ASSOC);
    $db->close();

} catch (Throwable $e) {
    // Technische Details und Zugangsdaten nicht im Browser ausgeben.
    error_log('NetWatch database error: ' . $e->getMessage());
    $error = 'Die Datenbank ist momentan nicht erreichbar.';
}

function h(mixed $value): string
{
    return htmlspecialchars(
        (string) ($value ?? ''),
        ENT_QUOTES | ENT_SUBSTITUTE,
        'UTF-8'
    );
}

function formatTime(mixed $value): string
{
    if ($value === null || $value === '') {
        return 'Noch keine Prüfung';
    }

    $timestamp = strtotime((string) $value);

    return $timestamp === false
        ? (string) $value
        : date('d.m.Y H:i:s', $timestamp);
}
?>
<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>NetWatch – Dashboard</title>

    <style>
        :root {
            color-scheme: dark;
            --background: #10151e;
            --panel: #192230;
            --border: #2b3748;
            --text: #edf2f7;
            --muted: #9aa9bc;
            --green: #55d6a0;
            --red: #ff7777;
            --blue: #80b7ff;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            background: var(--background);
            color: var(--text);
            font-family: system-ui, -apple-system, "Segoe UI", sans-serif;
            line-height: 1.5;
        }

        .container {
            width: min(1100px, calc(100% - 32px));
            margin: 0 auto;
        }

        header {
            border-bottom: 1px solid var(--border);
            background: #151d29;
        }

        .header-content {
            min-height: 84px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
        }

        h1, h2, p {
            margin-top: 0;
        }

        h1 {
            margin-bottom: 2px;
            font-size: 1.65rem;
        }

        h2 {
            margin-bottom: 16px;
            font-size: 1.1rem;
        }

        .subtitle, .muted {
            color: var(--muted);
        }

        .subtitle {
            margin: 0;
            font-size: .9rem;
        }

        .refresh {
            color: var(--muted);
            font-size: .85rem;
            text-align: right;
        }

        main {
            padding: 28px 0 48px;
        }

        .summary {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 16px;
            margin-bottom: 28px;
        }

        .card, .panel {
            background: var(--panel);
            border: 1px solid var(--border);
            border-radius: 12px;
        }

        .card {
            padding: 20px;
        }

        .card-label {
            margin-bottom: 8px;
            color: var(--muted);
            font-size: .9rem;
        }

        .card-value {
            font-size: 2rem;
            font-weight: 700;
            line-height: 1.2;
        }

        .online {
            color: var(--green);
        }

        .offline {
            color: var(--red);
        }

        .unknown {
            color: var(--muted);
        }

        .panel {
            margin-bottom: 24px;
            padding: 22px;
            min-width: 0;
        }

        .table-wrap {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            font-size: .92rem;
        }

        th, td {
            padding: 13px 12px;
            border-bottom: 1px solid var(--border);
            white-space: nowrap;
        }

        th {
            color: var(--muted);
            font-size: .8rem;
            font-weight: 600;
        }

        tbody tr:last-child td {
            border-bottom: 0;
        }

        .status {
            display: inline-block;
            padding: 3px 9px;
            border-radius: 999px;
            font-size: .8rem;
            font-weight: 700;
        }

        .status.online {
            background: #163c31;
        }

        .status.offline {
            background: #48252b;
        }

        .status.unknown {
            background: #303b4a;
        }

        .message {
            padding: 16px;
            border: 1px solid var(--border);
            border-radius: 8px;
            color: var(--muted);
        }

        .error {
            color: var(--red);
            border-color: #70404a;
        }

        footer {
            padding: 20px 0;
            border-top: 1px solid var(--border);
            color: var(--muted);
            font-size: .85rem;
        }

        @media (max-width: 650px) {
            .summary {
                grid-template-columns: 1fr;
                gap: 10px;
            }

            .card {
                padding: 16px;
            }

            .header-content {
                align-items: flex-start;
                padding: 18px 0;
            }

            .refresh {
                max-width: 115px;
            }

            .panel {
                padding: 16px;
            }
        }
    </style>
</head>

<body>
<header>
    <div class="container header-content">
        <div>
            <h1>NetWatch</h1>
            <p class="subtitle">Netzwerk-Monitoring Dashboard</p>
        </div>
        <div class="refresh">
            Automatische Aktualisierung<br>
            alle 60 Sekunden
        </div>
    </div>
</header>

<main class="container">
    <section class="summary" aria-label="Systemübersicht">
        <div class="card">
            <div class="card-label">Überwachte Systeme</div>
            <div class="card-value"><?= $totalSystems ?></div>
        </div>

        <div class="card">
            <div class="card-label">Online</div>
            <div class="card-value online"><?= $onlineSystems ?></div>
        </div>

        <div class="card">
            <div class="card-label">Offline</div>
            <div class="card-value offline"><?= $offlineSystems ?></div>
        </div>
    </section>

    <?php if ($error !== null): ?>
        <div class="message error">
            <strong>Verbindungsfehler</strong><br>
            <?= h($error) ?>
            Bitte prüfe, ob MariaDB läuft und die Zugangsdaten in
            Docker Compose korrekt gesetzt sind.
        </div>
    <?php else: ?>

        <section class="panel">
            <h2>Systemstatus</h2>

            <?php if (!$systems): ?>
                <p class="message">Es sind noch keine Systeme angelegt.</p>
            <?php else: ?>
                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>System</th>
                                <th>Status</th>
                                <th>Letzte Prüfung</th>
                                <th>Antwortzeit</th>
                            </tr>
                        </thead>
                        <tbody>
                        <?php foreach ($systems as $system): ?>
                            <?php
                            $status = $system['status_name'] ?? 'UNBEKANNT';
                            $statusClass = match ($status) {
                                'ONLINE' => 'online',
                                'OFFLINE' => 'offline',
                                default => 'unknown'
                            };
                            ?>
                            <tr>
                                <td><?= h($system['system_name']) ?></td>
                                <td>
                                    <span class="status <?= h($statusClass) ?>">
                                        <?= h($status) ?>
                                    </span>
                                </td>
                                <td><?= h(formatTime($system['check_date'])) ?></td>
                                <td>
                                    <?= $system['response_time'] !== null
                                        ? h(number_format(
                                            (float) $system['response_time'],
                                            3,
                                            ',',
                                            '.'
                                        )) . ' ms'
                                        : '–' ?>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            <?php endif; ?>
        </section>

        <section class="panel">
            <h2>Letzte Prüfungen</h2>

            <?php if (!$history): ?>
                <p class="message">Es liegen noch keine Prüfergebnisse vor.</p>
            <?php else: ?>
                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>System</th>
                                <th>Prüfzeitpunkt</th>
                                <th>Status</th>
                                <th>Antwortzeit</th>
                            </tr>
                        </thead>
                        <tbody>
                        <?php foreach ($history as $check): ?>
                            <?php
                            $statusClass = match ($check['status_name']) {
                                'ONLINE' => 'online',
                                'OFFLINE' => 'offline',
                                default => 'unknown'
                            };
                            ?>
                            <tr>
                                <td><?= h($check['system_name']) ?></td>
                                <td><?= h(formatTime($check['check_date'])) ?></td>
                                <td>
                                    <span class="status <?= h($statusClass) ?>">
                                        <?= h($check['status_name']) ?>
                                    </span>
                                </td>
                                <td>
                                    <?= $check['response_time'] !== null
                                        ? h(number_format(
                                            (float) $check['response_time'],
                                            3,
                                            ',',
                                            '.'
                                        )) . ' ms'
                                        : '–' ?>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            <?php endif; ?>
        </section>

    <?php endif; ?>
</main>

<footer>
    <div class="container">
        NetWatch · Netzwerkstatus und Prüfverlauf
    </div>
</footer>

<script>
    window.setTimeout(() => window.location.reload(), 60000);
</script>
</body>
</html>
