# 部署脚本 - 将Hugo博客推送到GitHub
# 使用方法: .\deploy.ps1 "提交信息"

param(
    [Parameter(Mandatory=$true)]
    [string]$CommitMessage
)

Write-Host "🚀 开始部署博客到GitHub..." -ForegroundColor Cyan

# 确保停止当前运行的Hugo服务器
Write-Host "📋 停止当前运行的Hugo服务器..." -ForegroundColor Yellow
Stop-Process -Name hugo -ErrorAction SilentlyContinue

# 添加所有更改到Git
Write-Host "📁 添加所有更改到Git..." -ForegroundColor Yellow
git add .

# 提交更改
Write-Host "💾 提交更改: $CommitMessage" -ForegroundColor Yellow
git commit -m $CommitMessage

# 推送到GitHub
Write-Host "📤 推送到GitHub..." -ForegroundColor Yellow
git push origin main

Write-Host "✅ 部署完成!" -ForegroundColor Green
Write-Host "GitHub Actions将自动构建并部署你的博客" -ForegroundColor Cyan
Write-Host "你可以在GitHub仓库的Actions标签页查看部署进度" -ForegroundColor Cyan
Write-Host "博客将部署在: https://kobewl.github.io/My_Blog/" -ForegroundColor Cyan 