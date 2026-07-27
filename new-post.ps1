# redduk.log 글 작성 도우미
# 실행: .\new-post.ps1

$ErrorActionPreference = 'Stop'
$postsPath = Join-Path $PSScriptRoot 'posts.json'

$title = Read-Host '글 제목'
if ([string]::IsNullOrWhiteSpace($title)) { throw '글 제목은 비워 둘 수 없습니다.' }

$category = Read-Host '분류 (새 분류도 바로 입력 가능)'
if ([string]::IsNullOrWhiteSpace($category)) { throw '분류는 비워 둘 수 없습니다.' }

Write-Host '본문을 입력하세요. 끝내려면 새 줄에 END만 입력합니다.' -ForegroundColor DarkGray
$lines = [System.Collections.Generic.List[string]]::new()
while ($true) {
  $line = Read-Host
  if ($line -eq 'END') { break }
  $lines.Add($line)
}

$idBase = ($title.ToLowerInvariant() -replace '[^a-z0-9가-힣]+', '-') -replace '(^-|-$)', ''
if ([string]::IsNullOrWhiteSpace($idBase)) { $idBase = 'post' }
$id = "$idBase-$(Get-Date -Format 'yyyyMMddHHmmss')"
$post = [ordered]@{
  id = $id
  title = $title.Trim()
  category = $category.Trim()
  date = Get-Date -Format 'yyyy-MM-dd'
  body = ($lines -join "`n")
}

$existing = @()
if (Test-Path $postsPath) { $existing = Get-Content $postsPath -Raw -Encoding utf8 | ConvertFrom-Json }
$allPosts = @($post)
$allPosts += $existing
$allPosts | ConvertTo-Json -Depth 4 | Set-Content -Path $postsPath -Encoding utf8
Write-Host "게시일 $($post.date)로 글을 저장했습니다: $postsPath" -ForegroundColor Green
Write-Host '이제 git add posts.json, git commit, git push를 실행하면 GitHub Pages에 게시됩니다.' -ForegroundColor DarkGray
