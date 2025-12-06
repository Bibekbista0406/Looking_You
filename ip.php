<?php
// Create ip.txt with detailed information
$timestamp = date('Y-m-d H:i:s');
$ip = '';

// Get IP address
if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
    $ip = $_SERVER['HTTP_CLIENT_IP'];
} elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
    $ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
} else {
    $ip = $_SERVER['REMOTE_ADDR'];
}

// Get user agent and other info
$userAgent = $_SERVER['HTTP_USER_AGENT'] ?? 'Unknown';
$referrer = $_SERVER['HTTP_REFERER'] ?? 'Direct visit';
$requestUri = $_SERVER['REQUEST_URI'];
$requestMethod = $_SERVER['REQUEST_METHOD'];
$httpHost = $_SERVER['HTTP_HOST'];

// Create detailed log entry
$logEntry = "══════════════════════════════════════════════════════════════════════════\n";
$logEntry .= "🆕 NEW VISITOR DETECTED\n";
$logEntry .= "══════════════════════════════════════════════════════════════════════════\n";
$logEntry .= "Timestamp: {$timestamp}\n";
$logEntry .= "IP Address: {$ip}\n";
$logEntry .= "User Agent: {$userAgent}\n";
$logEntry .= "Referrer: {$referrer}\n";
$logEntry .= "Request URI: {$requestUri}\n";
$logEntry .= "HTTP Method: {$requestMethod}\n";
$logEntry .= "HTTP Host: {$httpHost}\n";

// Get additional headers
$headers = [
    'Accept' => $_SERVER['HTTP_ACCEPT'] ?? 'N/A',
    'Accept-Language' => $_SERVER['HTTP_ACCEPT_LANGUAGE'] ?? 'N/A',
    'Accept-Encoding' => $_SERVER['HTTP_ACCEPT_ENCODING'] ?? 'N/A',
    'Connection' => $_SERVER['HTTP_CONNECTION'] ?? 'N/A',
    'Cache-Control' => $_SERVER['HTTP_CACHE_CONTROL'] ?? 'N/A'
];

$logEntry .= "\n📋 REQUEST HEADERS:\n";
foreach ($headers as $key => $value) {
    $logEntry .= "  {$key}: {$value}\n";
}

$logEntry .= "══════════════════════════════════════════════════════════════════════════\n\n";

// Save to ip.txt
file_put_contents('ip.txt', $logEntry, FILE_APPEND);

// Also save to saved.ip.txt
file_put_contents('saved.ip.txt', $logEntry, FILE_APPEND);

// Create individual IP log file
$ipLogFile = "logs/ip_{$ip}_" . date('Y-m-d') . ".log";
if (!is_dir('logs')) {
    mkdir('logs', 0777, true);
}
file_put_contents($ipLogFile, $logEntry, FILE_APPEND);

// Save to CSV for easy parsing
$csvLine = "\"{$timestamp}\",\"{$ip}\",\"{$userAgent}\",\"{$referrer}\",\"{$requestUri}\"\n";
file_put_contents('logs/ip_log.csv', $csvLine, FILE_APPEND);
?>