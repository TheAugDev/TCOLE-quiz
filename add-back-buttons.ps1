# PowerShell script to add back button to all HTML files in Week 5-6 and Week 7-8 directories

$backButtonHTML = @"
    
    <!-- Back to Portal Button -->
    <div class="fixed top-4 left-4 z-50">
        <a href="../index.html" class="inline-flex items-center gap-2 bg-indigo-600 hover:bg-indigo-700 text-white px-4 py-2 rounded-lg shadow-lg transition-all duration-200 hover:shadow-xl group">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 group-hover:-translate-x-1 transition-transform" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
            </svg>
            <span class="font-medium">Back to Portal</span>
        </a>
    </div>

"@

# Get all HTML files from both directories
$htmlFiles = @()
$htmlFiles += Get-ChildItem "Week 5-6\*.html" -File
$htmlFiles += Get-ChildItem "Week 7-8\*.html" -File

$processedCount = 0
$skippedCount = 0

foreach ($file in $htmlFiles) {
    Write-Host "Processing: $($file.Name)"
    
    # Read the file content
    $content = Get-Content $file.FullName -Raw
    
    # Check if back button already exists
    if ($content -match "Back to Portal") {
        Write-Host "  - Skipping (back button already exists)"
        $skippedCount++
        continue
    }
    
    # Find body tag patterns and replace
    $patterns = @(
        '(<body[^>]*>)\s*(\r?\n)\s*(<div class="max-w-4xl mx-auto">)',
        '(<body[^>]*>)\s*(\r?\n)\s*(<div class="max-w-6xl mx-auto">)',
        '(<body[^>]*>)\s*(\r?\n)\s*(<div class="container mx-auto)',
        '(<body[^>]*>)\s*(\r?\n)\s*(<div[^>]*class="[^"]*mx-auto[^"]*"[^>]*>)'
    )
    
    $replaced = $false
    foreach ($pattern in $patterns) {
        if ($content -match $pattern) {
            $newContent = $content -replace $pattern, "`$1$backButtonHTML`$3"
            Set-Content $file.FullName -Value $newContent -NoNewline
            Write-Host "  - Successfully added back button"
            $processedCount++
            $replaced = $true
            break
        }
    }
    
    if (-not $replaced) {
        Write-Host "  - Warning: Could not find suitable pattern to insert back button"
    }
}

Write-Host "`nSummary:"
Write-Host "- Processed: $processedCount files"
Write-Host "- Skipped: $skippedCount files"
Write-Host "- Total: $($htmlFiles.Count) files"
