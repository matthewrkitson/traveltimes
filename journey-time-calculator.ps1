$ErrorActionPreference = "Stop"

# $origin = "CB4 3ES"
$origin = "PE28 4NE"
$destination = "Boxworth" # "PE28 4NE"

$startDate = [DateTime]::Parse("2017-11-20")
$startTime = [TimeSpan]::Parse("16:00:00")
$endTime = [TimeSpan]::Parse("19:00:00")
$interval = [TimeSpan]::Parse("00:05:00")

$startAt = $startDate + $startTime
$endAt = $startDate + $endTime
$epoc = [DateTime]::Parse("1970-01-01")


$startTimes = @()
$durations = @()
$durationsInTraffic = @()

for ($start = $startAt; $start -lt $endAt; $start = $start + $interval)
{
    $start

    $departureTime = [int](($start - $epoc).TotalSeconds)

    $parameters = @{
    "origins" = $origin
    "destinations" = $destination
    "key" = "AIzaSyAHS48QyxZtD93eRm5XsGtQXebm3Z_9iOM"
    "mode" = "driving"
    "traffic_model" = "best_guess" # best_guess, optimistic, pessimistic
    "departure_time" = $departureTime
    }

    $response = Invoke-WebRequest -Body $parameters -Uri "https://maps.googleapis.com/maps/api/distancematrix/json"
    $json = ConvertFrom-Json $response.Content

    $startTimes += $start
    $durations += $json.rows[0].elements.duration
    $durationsInTraffic += $json.rows[0].elements.duration_in_traffic
}

"Starting from: $($json.origin_addresses[0])"
"Travelling to: $($json.destination_addresses[0])"
""
"Start time, Duration in traffic, Seconds"

for ($i = 0; $i -lt $durations.Count; $i++)
{
    $startTime = $startTimes[$i]
    $durationText = $durations[$i].text
    $durationSeconds = $durations[$i].value
    $durationInTrafficText = $durationsInTraffic[$i].text
    $durationInTrafficSeconds = $durationsInTraffic[$i].value

    "$startTime, $durationInTrafficText, $durationInTrafficSeconds"
}
