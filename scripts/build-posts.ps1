$ErrorActionPreference = 'Stop'

$rootPath = Split-Path -Parent $PSScriptRoot
$sourcePath = Join-Path $rootPath 'posts'
$outputPath = Join-Path $rootPath 'posts.json'

if (-not (Test-Path -LiteralPath $sourcePath)) {
  throw "글 폴더를 찾을 수 없습니다: $sourcePath"
}

$requiredFields = @('title', 'category', 'date', 'id')
$seenIds = [System.Collections.Generic.HashSet[string]]::new()
$posts = foreach ($file in Get-ChildItem -LiteralPath $sourcePath -Filter '*.txt' -File | Sort-Object Name) {
  $source = Get-Content -LiteralPath $file.FullName -Raw -Encoding utf8
  $sections = $source -split '(?m)^\s*---\s*$', 2
  if ($sections.Count -ne 2) {
    throw "$($file.Name): 메타데이터와 본문 사이에 --- 줄이 필요합니다."
  }

  $metadata = @{}
  foreach ($line in ($sections[0] -split '\r?\n')) {
    if ([string]::IsNullOrWhiteSpace($line)) { continue }
    if ($line -notmatch '^(?<key>title|category|date|id)\s*:\s*(?<value>.+?)\s*$') {
      throw "$($file.Name): 올바르지 않은 메타데이터입니다: $line"
    }
    $metadata[$Matches.key] = $Matches.value
  }

  foreach ($field in $requiredFields) {
    if ([string]::IsNullOrWhiteSpace($metadata[$field])) {
      throw "$($file.Name): $field 값이 필요합니다."
    }
  }

  $parsedDate = [datetime]::MinValue
  if (-not [datetime]::TryParseExact($metadata.date, 'yyyy-MM-dd', [Globalization.CultureInfo]::InvariantCulture, [Globalization.DateTimeStyles]::None, [ref]$parsedDate)) {
    throw "$($file.Name): date는 YYYY-MM-DD 형식이어야 합니다."
  }
  if ($metadata.id -notmatch '^[a-z0-9가-힣]+(?:-[a-z0-9가-힣]+)*$') {
    throw "$($file.Name): id는 영문 소문자, 숫자, 한글, 하이픈만 사용할 수 있습니다."
  }
  if (-not $seenIds.Add($metadata.id)) {
    throw "$($file.Name): 중복된 id입니다: $($metadata.id)"
  }

  [ordered]@{
    id = $metadata.id
    title = $metadata.title
    category = $metadata.category
    date = $metadata.date
    body = $sections[1].Trim()
  }
}

$posts | ConvertTo-Json -Depth 3 | Set-Content -LiteralPath $outputPath -Encoding utf8
Write-Host "$($posts.Count)개의 글을 posts.json에 반영했습니다." -ForegroundColor Green
