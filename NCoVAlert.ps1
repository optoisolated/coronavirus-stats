<#
    Title   : NCoVAlert.ps1
    Author  : Optoisolated
    Created : 30/1/2020
    Purpose : Coronavirus Alerts
    Descrip : Scrapes the Wiki page on the 2019-nCoV Wuhan Coronavirus
              Outbreak for the current reported cases
#>
    CLS
    $URL = "https://en.wikipedia.org/wiki/2019%E2%80%9320_Wuhan_coronavirus_outbreak"
    $Match = "*confirmed cases with*"
    $webClient = New-Object System.Net.Webclient
    $rawHTML = $webClient.DownloadString($url).Split("`n")

    $x = 0
    ForEach ($Line in  $rawHTML) {
        #Find the initial Line, and separate it all out by element
        If ($Line -like $Match) {
            $Elements = $Line.Split("<")
            ForEach ($Element in $Elements) {
                #Find the line with the case count on it
                If ($Element -like $Match) {
                    #Clean the line up and return it
                    $DataReturn = $Element.Replace("center> ","")
                Break
                }
            }      
        }
    }
    
    #Calculate Mortality Rate
    $BreakDown = $DataReturn.Split(" ")
    $Deaths = [int]$Breakdown[4] 
    $Cases = [int]$Breakdown[0] 
    [float]$Ratio = ($Deaths / $Cases) * 100
    $MortalityRate = "$([math]::Round($Ratio,2))%"   

    $Result = "2019-nCoV Patients as of $(Get-Date): $Cases confirmed cases, $Deaths deaths | Estimated mortality rate: $MortalityRate"
 
    #This is the returned result, pipe this output wherever you need it.
    $Result
