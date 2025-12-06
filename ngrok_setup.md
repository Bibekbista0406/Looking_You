# Ngrok Setup Instructions for Look_For_Kri

## 1. Create Ngrok Account
1. Go to https://ngrok.com
2. Sign up for a free account
3. Verify your email address

## 2. Get Your Authtoken
1. After logging in, go to: https://dashboard.ngrok.com/get-started/your-authtoken
2. Copy your authtoken (it looks like: `2abc3def4ghi5jkl6mno7pqr8stu9vwx0yz1`)

## 3. Configure Ngrok in Look_For_Kri
When you choose option 2 (Ngrok) in the tool:
- It will ask for your authtoken
- Paste the token you copied
- The tool will save it for future use

## 4. Manual Ngrok Setup (Alternative)
If the automatic setup fails, run these commands:

```bash
# Download ngrok
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
tar -xzf ngrok-v3-stable-linux-amd64.tgz
rm ngrok-v3-stable-linux-amd64.tgz
chmod +x ngrok

# Add your authtoken
./ngrok config add-authtoken YOUR_AUTH_TOKEN_HERE

# Test ngrok
./ngrok http 8080