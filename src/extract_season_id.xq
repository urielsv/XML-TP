
declare namespace sr = "http://schemas.sportradar.com/sportsapi/rugby-league/v3";
declare variable $season_prefix external;
declare variable $season_year external;

declare function local:get-id($NAME_PREFIX as xs:string, $YEAR as xs:integer) as xs:string {
    let $season := doc('../data/seasons.xml')//sr:season
                   [fn:contains(@name, $NAME_PREFIX) and xs:integer(@year) = $YEAR]
    return if (empty($season)) then concat("No season id found for ", $NAME_PREFIX, " and ", $YEAR) else string($season/@id)
};

local:get-id($season_prefix, $season_year)