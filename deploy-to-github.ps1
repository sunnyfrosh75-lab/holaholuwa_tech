# Deploy HORLAHOLUWA Project to GitHub
# This script will initialize a Git repository and push your project

$projectPath = "C:\Users\Administrator\Desktop\html site"
$gitRepo = "https://github.com/sunnyfrosh75-lab/holaholuwa_tech.git"
$gitEmail = "ajileyeolaoluwa471@gmail.com"
$gitName = "HORLAHOLUWA"

Write-Host "======================================"
Write-Host "GitHub Deployment Script"
Write-Host "======================================"
Write-Host ""

# Check if Git is installed
Write-Host "[1/5] Checking Git installation..."
$gitPath = "C:\Program Files\Git\bin\git.exe"
if (-not (Test-Path $gitPath)) {
    Write-Host "Git not found. Installing Git..."
    try {
        $gitInstallerUrl = "https://github.com/git-for-windows/git/releases/download/v2.42.0.windows.1/Git-2.42.0-64-bit.exe"
        $installerPath = "$env:TEMP\git-installer.exe"
        Write-Host "Downloading Git installer..."
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $gitInstallerUrl -OutFile $installerPath
        Write-Host "Running Git installer..."
        & $installerPath /SILENT /INSTALL="C:\Program Files\Git"
        Start-Sleep -Seconds 10
        Remove-Item $installerPath -Force
        Write-Host "Git installed successfully!"
    } catch {
        Write-Host "Error installing Git: $_"
        exit 1
    }
}

# Add Git to PATH
$env:Path += ";C:\Program Files\Git\bin"

# Verify Git
Write-Host "[2/5] Verifying Git..."
& "C:\Program Files\Git\bin\git.exe" --version
if ($LASTEXITCODE -ne 0) {
    Write-Host "Git verification failed!"
    exit 1
}

# Navigate to project directory
Write-Host "[3/5] Initializing Git repository..."
cd $projectPath

# Check if .git directory exists
if (Test-Path ".git") {
    Write-Host "Git repository already initialized."
} else {
    # Initialize git repository
    & "C:\Program Files\Git\bin\git.exe" init
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to initialize Git repository!"
        exit 1
    }
}

# Configure Git
Write-Host "[4/5] Configuring Git..."
& "C:\Program Files\Git\bin\git.exe" config user.email $gitEmail
& "C:\Program Files\Git\bin\git.exe" config user.name $gitName

# Check if remote origin exists
$remoteExists = & "C:\Program Files\Git\bin\git.exe" remote get-url origin 2>&1
if ($remoteExists -like "fatal:*" -or $remoteExists -eq "") {
    & "C:\Program Files\Git\bin\git.exe" remote add origin $gitRepo
    Write-Host "Remote repository added: $gitRepo"
} else {
    Write-Host "Remote repository already configured: $remoteExists"
}

# Create .gitignore if it doesn't exist
if (-not (Test-Path ".gitignore")) {
    @"
# Dependencies
node_modules/
.npm

# Environment
.env
.env.local

# OS
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo

# Build
dist/
build/
.parcel-cache/

# Logs
*.log
npm-debug.log*
"@ | Out-File -FilePath ".gitignore" -Encoding UTF8
    Write-Host "Created .gitignore"
}

# Create README if it doesn't exist
if (-not (Test-Path "README.md")) {
    @"
# HORLAHOLUWA - Professional Website Developer & Designer

A modern, responsive portfolio website showcasing web development, web design, and automation services.

## Features

- **Modern Design System** - Professional color palette and typography
- **Responsive Layout** - Mobile-first responsive design
- **Portfolio Gallery** - Showcase projects with filtering
- **Contact Form** - Professional contact form with validation
- **SEO Optimized** - Proper meta tags and semantic HTML
- **Smooth Animations** - Scroll reveal effects and transitions
- **Dark Mode Ready** - Professional dark theme

## Pages

- **Home** - Hero section with metrics and CTA
- **About** - Professional bio and value propositions
- **Services** - Detailed service offerings
- **Portfolio** - Project showcase with filtering
- **Contact** - Contact form and information

## Technologies

- HTML5
- CSS3 (Custom Properties & Grid)
- Vanilla JavaScript
- Responsive Design

## Getting Started

1. Clone the repository:
\`\`\`bash
git clone https://github.com/sunnyfrosh75-lab/holaholuwa_tech.git
\`\`\`

2. Open \`index.html\` in your web browser

3. Customize content as needed

## File Structure

\`\`\`
holaholuwa_tech/
├── index.html
├── about.html
├── services.html
├── portfolio.html
├── contact.html
├── project-holaoluwa.html
├── style.css
├── script.js
└── olaoluwa.png
\`\`\`

## Contact

- **Email:** ajileyeolaoluwa471@gmail.com
- **Phone:** +234 704 676 4269
- **WhatsApp:** https://wa.me/2347046764269

## License

© 2024 HORLAHOLUWA. All rights reserved.
"@ | Out-File -FilePath "README.md" -Encoding UTF8
    Write-Host "Created README.md"
}

# Stage and commit files
Write-Host "[5/5] Pushing to GitHub..."
& "C:\Program Files\Git\bin\git.exe" add -A
$status = & "C:\Program Files\Git\bin\git.exe" status --porcelain
if ($status) {
    & "C:\Program Files\Git\bin\git.exe" commit -m "Initial commit: HORLAHOLUWA portfolio website"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Warning: Commit had issues, but continuing..."
    }
} else {
    Write-Host "No changes to commit - repository already up to date."
}

# Push to GitHub
& "C:\Program Files\Git\bin\git.exe" branch -M main
& "C:\Program Files\Git\bin\git.exe" push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "======================================"
    Write-Host "✅ SUCCESS! Project deployed to GitHub"
    Write-Host "======================================"
    Write-Host ""
    Write-Host "Repository: $gitRepo"
    Write-Host ""
    Write-Host "Your project is now live on GitHub!"
} else {
    Write-Host ""
    Write-Host "======================================"
    Write-Host "⚠️  Push encountered issues"
    Write-Host "======================================"
    Write-Host ""
    Write-Host "Possible reasons:"
    Write-Host "1. Authentication required - GitHub may prompt for credentials"
    Write-Host "2. Repository access - check your permissions on GitHub"
    Write-Host "3. Network issues - check your internet connection"
    Write-Host ""
    Write-Host "Try running this command manually:"
    Write-Host "git push -u origin main"
}

Read-Host "Press Enter to exit"
