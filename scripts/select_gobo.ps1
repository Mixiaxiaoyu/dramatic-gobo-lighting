param(
    [Parameter(Mandatory = $true)]
    [string]$Brief,

    [string]$Root,

    [ValidateRange(1, 10)]
    [int]$Top = 5,

    [ValidateSet("all", "windows", "plants", "caustics", "lines", "abstract")]
    [string]$Family = "all",

    [string]$GoboFile,

    [switch]$Json
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function New-WeightedTerm {
    param(
        [string]$Term,
        [int]$Weight
    )

    [pscustomobject]@{
        Term   = $Term
        Weight = $Weight
    }
}

function Get-DefaultRoot {
    (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}

function Get-TermHits {
    param(
        [string]$BriefText,
        [object[]]$Keywords
    )

    $score = 0
    $hits = New-Object System.Collections.Generic.List[string]

    foreach ($keyword in $Keywords) {
        $term = $keyword.Term.ToLowerInvariant()
        if ($BriefText.Contains($term)) {
            $score += $keyword.Weight
            if (-not $hits.Contains($keyword.Term)) {
                [void]$hits.Add($keyword.Term)
            }
        }
    }

    [pscustomobject]@{
        Score = $score
        Hits  = [string[]]$hits
    }
}

function Get-ContextBoost {
    param(
        [string]$BriefText,
        [string]$FamilyName,
        [string]$Subtype
    )

    $boostScore = 0
    $boostHits = New-Object System.Collections.Generic.List[string]
    $targetKey = "{0}/{1}" -f $FamilyName, $Subtype

    $rules = @(
        @{
            Terms    = @("portrait", "beauty", "fashion", "face", "person")
            Targets  = @("windows/blinds", "windows/window", "plants/palm", "plants/tree")
            Weight   = 3
            HitLabel = "portrait"
        },
        @{
            Terms    = @("interior", "room", "hotel", "office", "loft", "church")
            Targets  = @("windows/blinds", "windows/window")
            Weight   = 4
            HitLabel = "interior"
        },
        @{
            Terms    = @("product", "perfume", "watch", "jewelry", "bottle", "cosmetic")
            Targets  = @("lines/lines", "windows/window", "caustics/caustics")
            Weight   = 3
            HitLabel = "product"
        },
        @{
            Terms    = @("water", "pool", "underwater", "ocean", "bath", "spa")
            Targets  = @("caustics/caustics")
            Weight   = 8
            HitLabel = "water"
        },
        @{
            Terms    = @("tropical", "resort", "balcony", "summer", "vacation")
            Targets  = @("plants/palm", "caustics/caustics")
            Weight   = 4
            HitLabel = "tropical"
        },
        @{
            Terms    = @("dream", "experimental", "club", "stage", "concert", "dreamy")
            Targets  = @("abstract/abstract", "lines/lines")
            Weight   = 4
            HitLabel = "experimental"
        },
        @{
            Terms    = @("dramatic", "cinematic", "editorial", "moody")
            Targets  = @("windows/blinds", "windows/window", "abstract/abstract")
            Weight   = 2
            HitLabel = "dramatic"
        }
    )

    foreach ($rule in $rules) {
        $matched = $false
        foreach ($term in $rule.Terms) {
            if ($BriefText.Contains($term.ToLowerInvariant())) {
                $matched = $true
                break
            }
        }

        if ($matched -and $rule.Targets.Contains($targetKey)) {
            $boostScore += $rule.Weight
            if (-not $boostHits.Contains($rule.HitLabel)) {
                [void]$boostHits.Add($rule.HitLabel)
            }
        }
    }

    [pscustomobject]@{
        Score = $boostScore
        Hits  = [string[]]$boostHits
    }
}

function Get-FamilySpecs {
    @(
        @{
            Family   = "windows"
            Subtype  = "blinds"
            Glob     = "assets\gobos\windows\*Blinds*.jpg"
            Rank     = 70
            Base     = 16
            Note     = "Hard venetian-blind stripes for noir portraits, offices, and hotel interiors."
            Keywords = @(
                (New-WeightedTerm "blinds" 8),
                (New-WeightedTerm "blind" 8),
                (New-WeightedTerm "venetian" 9),
                (New-WeightedTerm "slats" 7),
                (New-WeightedTerm "slat" 7),
                (New-WeightedTerm "stripes" 6),
                (New-WeightedTerm "stripe" 6),
                (New-WeightedTerm "noir" 8),
                (New-WeightedTerm "interrogation" 10),
                (New-WeightedTerm "striped shadow" 9),
                (New-WeightedTerm "shadow stripes" 9),
                (New-WeightedTerm "slashed light" 9)
            )
        },
        @{
            Family   = "windows"
            Subtype  = "window"
            Glob     = "assets\gobos\windows\*Window*.jpg"
            Rank     = 65
            Base     = 14
            Note     = "Architectural window panes and rectangular projections for lofts, churches, and shaped sunbeams."
            Keywords = @(
                (New-WeightedTerm "window" 8),
                (New-WeightedTerm "windows" 8),
                (New-WeightedTerm "pane" 7),
                (New-WeightedTerm "grid" 7),
                (New-WeightedTerm "architectural" 6),
                (New-WeightedTerm "loft" 7),
                (New-WeightedTerm "chapel" 8),
                (New-WeightedTerm "sunbeam" 6),
                (New-WeightedTerm "window shadow" 8),
                (New-WeightedTerm "rectangular shadow" 8),
                (New-WeightedTerm "pane shadow" 8)
            )
        },
        @{
            Family   = "plants"
            Subtype  = "palm"
            Glob     = "assets\gobos\plants\*Palm*.jpg"
            Rank     = 55
            Base     = 12
            Note     = "Large tropical leaf breakup for balcony light, resort editorials, and warm vacation mood."
            Keywords = @(
                (New-WeightedTerm "palm" 9),
                (New-WeightedTerm "tropical" 8),
                (New-WeightedTerm "resort" 7),
                (New-WeightedTerm "balcony" 7),
                (New-WeightedTerm "leaf" 6),
                (New-WeightedTerm "foliage" 6),
                (New-WeightedTerm "leaf shadow" 8),
                (New-WeightedTerm "dappled light" 8),
                (New-WeightedTerm "sun-dappled" 8)
            )
        },
        @{
            Family   = "plants"
            Subtype  = "tree"
            Glob     = "assets\gobos\plants\*Tree*.jpg"
            Rank     = 52
            Base     = 12
            Note     = "Organic leaf dappling for gardens, woodland shade, and believable outdoor breakup."
            Keywords = @(
                (New-WeightedTerm "tree" 8),
                (New-WeightedTerm "trees" 8),
                (New-WeightedTerm "leaf" 7),
                (New-WeightedTerm "leaves" 7),
                (New-WeightedTerm "forest" 7),
                (New-WeightedTerm "garden" 6),
                (New-WeightedTerm "dappled" 7),
                (New-WeightedTerm "leaf shadow" 7),
                (New-WeightedTerm "tree shadow" 9),
                (New-WeightedTerm "filtered sunlight" 8)
            )
        },
        @{
            Family   = "caustics"
            Subtype  = "caustics"
            Glob     = "assets\gobos\caustics\*.jpg"
            Rank     = 50
            Base     = 10
            Note     = "Water caustics and ripple refractions for pools, bathrooms, spas, and underwater shimmer."
            Keywords = @(
                (New-WeightedTerm "caustic" 10),
                (New-WeightedTerm "caustics" 10),
                (New-WeightedTerm "water" 8),
                (New-WeightedTerm "pool" 9),
                (New-WeightedTerm "underwater" 10),
                (New-WeightedTerm "ripple" 8),
                (New-WeightedTerm "spa" 7),
                (New-WeightedTerm "water reflection" 10),
                (New-WeightedTerm "ripple light" 10),
                (New-WeightedTerm "pool reflection" 10)
            )
        },
        @{
            Family   = "lines"
            Subtype  = "lines"
            Glob     = "assets\gobos\lines\*.jpg"
            Rank     = 45
            Base     = 9
            Note     = "Graphic bars and narrow beams for minimalist product work, stage light, and sci-fi slashes."
            Keywords = @(
                (New-WeightedTerm "line" 8),
                (New-WeightedTerm "lines" 8),
                (New-WeightedTerm "bar" 7),
                (New-WeightedTerm "bars" 7),
                (New-WeightedTerm "graphic" 7),
                (New-WeightedTerm "minimal" 6),
                (New-WeightedTerm "scan" 8),
                (New-WeightedTerm "stripe" 5),
                (New-WeightedTerm "light bar" 9),
                (New-WeightedTerm "scan line" 9),
                (New-WeightedTerm "sci-fi" 8)
            )
        },
        @{
            Family   = "abstract"
            Subtype  = "abstract"
            Glob     = "assets\gobos\abstract\*.jpg"
            Rank     = 40
            Base     = 8
            Note     = "Broken abstract light for smoky, unstable, dreamlike, and experimental mood shifts."
            Keywords = @(
                (New-WeightedTerm "abstract" 9),
                (New-WeightedTerm "breakup" 8),
                (New-WeightedTerm "smoke" 7),
                (New-WeightedTerm "dream" 7),
                (New-WeightedTerm "experimental" 8),
                (New-WeightedTerm "broken light" 8),
                (New-WeightedTerm "textured haze" 8),
                (New-WeightedTerm "uneven breakup" 8)
            )
        }
    )
}

function Find-RequestedGobo {
    param(
        [object[]]$Catalog,
        [string]$Requested
    )

    $requestedText = $Requested.Trim()
    if (-not $requestedText) {
        return $null
    }

    $requestedName = [System.IO.Path]::GetFileName($requestedText)
    $requestedBase = [System.IO.Path]::GetFileNameWithoutExtension($requestedName)

    $exactFile = $Catalog |
        Where-Object { $_.File.Equals($requestedName, [System.StringComparison]::OrdinalIgnoreCase) } |
        Sort-Object Rank -Descending |
        Select-Object -First 1

    if ($exactFile) {
        return $exactFile
    }

    if ($requestedBase) {
        $exactBase = $Catalog |
            Where-Object {
                [System.IO.Path]::GetFileNameWithoutExtension($_.File).Equals($requestedBase, [System.StringComparison]::OrdinalIgnoreCase)
            } |
            Sort-Object Rank -Descending |
            Select-Object -First 1

        if ($exactBase) {
            return $exactBase
        }
    }

    return $null
}

if (-not $Root) {
    $Root = Get-DefaultRoot
}

$Root = (Resolve-Path $Root).Path
$briefText = $Brief.ToLowerInvariant()
$specs = Get-FamilySpecs
$catalog = New-Object System.Collections.Generic.List[object]

foreach ($spec in $specs) {
    if (-not $GoboFile -and $Family -ne "all" -and $spec.Family -ne $Family) {
        continue
    }

    $files = Get-ChildItem -Path (Join-Path $Root $spec.Glob) -File -ErrorAction SilentlyContinue | Sort-Object Name
    foreach ($file in $files) {
        $termResult = Get-TermHits -BriefText $briefText -Keywords $spec.Keywords
        $contextResult = Get-ContextBoost -BriefText $briefText -FamilyName $spec.Family -Subtype $spec.Subtype
        $hits = @($termResult.Hits + $contextResult.Hits) | Where-Object { $_ } | Select-Object -Unique
        $seed = [Math]::Abs(("{0}|{1}" -f $Brief, $file.FullName).GetHashCode())

        $catalog.Add([pscustomobject]@{
                Family  = $spec.Family
                Subtype = $spec.Subtype
                Score   = $spec.Base + $termResult.Score + $contextResult.Score
                Rank    = $spec.Rank
                Seed    = $seed
                File    = $file.Name
                Path    = $file.FullName
                Note    = $spec.Note
                Hits    = [string[]]$hits
            })
    }
}

if ($catalog.Count -eq 0) {
    throw "No gobo assets were found under '$Root'."
}

$selected = if ($GoboFile) {
    $manualMatch = Find-RequestedGobo -Catalog $catalog -Requested $GoboFile
    if (-not $manualMatch) {
        throw "Requested gobo '$GoboFile' was not found under '$Root'. Check references/gobo-catalog.md for valid names."
    }

    @($manualMatch)
}
else {
    $catalog |
        Sort-Object `
        @{ Expression = "Score"; Descending = $true }, `
        @{ Expression = "Rank"; Descending = $true }, `
        @{ Expression = "Seed"; Descending = $false } |
        Select-Object -First $Top
}

if ($Json) {
    $selected |
        Select-Object Family, Subtype, Score, File, Path, Note, Hits |
        ConvertTo-Json -Depth 4
    return
}

Write-Output ("Workspace root: {0}" -f $Root)
Write-Output ("Brief: {0}" -f $Brief)
if ($GoboFile) {
    Write-Output ("Manual gobo override: {0}" -f $GoboFile)
}
Write-Output "Candidates:"

$index = 1
foreach ($item in $selected) {
    $hits = @(@($item.Hits) | Where-Object { $_ })
    Write-Output ("{0}. {1}/{2}  score={3}" -f $index, $item.Family, $item.Subtype, $item.Score)
    Write-Output ("   file: {0}" -f $item.Path)
    if ($hits.Count -gt 0) {
        Write-Output ("   matched: {0}" -f ($hits -join ", "))
    }
    Write-Output ("   note: {0}" -f $item.Note)
    $index += 1
}
