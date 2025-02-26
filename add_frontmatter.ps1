# 添加Front Matter的PowerShell脚本
# 此脚本用于批量为文章添加front matter

# 遍历content/post目录下的所有文章
Get-ChildItem -Path "content/post" -Recurse -Filter "*.md" | ForEach-Object {
    $content = Get-Content -Path $_.FullName -Raw
    
    # 检查文件是否已经有front matter
    if ($content -notmatch "^---\s*\r?\n") {
        Write-Host "正在处理文件：" $_.FullName
        
        # 提取文件名作为标题
        $title = ($_.Name -replace "\.md$", "")
        
        # 确定分类
        $relativePath = $_.FullName -replace [regex]::Escape((Get-Location).Path + "\content\post\\"), ""
        $category = $relativePath.Split("\")[0]
        
        # 提取文章第一行作为标题（如果以#开头）
        $firstLine = $content -split "\r?\n" | Select-Object -First 1
        if ($firstLine -match "^#\s+(.+)$") {
            $title = $matches[1]
        }
        
        # 构建front matter
        $frontMatter = @"
---
title: "$title"
date: 2023-01-01T01:01:01+08:00
categories: ["$category"]
tags: ["$category"]
draft: false
---

"@
        
        # 添加front matter到文件开头
        $newContent = $frontMatter + $content
        $newContent | Set-Content -Path $_.FullName -Encoding utf8
        
        Write-Host "已添加front matter：" $title
    } else {
        Write-Host "文件已有front matter，跳过：" $_.FullName
    }
}

Write-Host "处理完成！" 