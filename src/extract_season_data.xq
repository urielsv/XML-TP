declare namespace sr = "http://schemas.sportradar.com/sportsapi/rugby-league/v3";

(:~~~~~~~~~~~~~~~:)
(:~ SEASON DATA ~:)
(:~~~~~~~~~~~~~~~:)
declare function local:season-xml() as node() {
    let $season_info := doc("../data/season_info.xml")//sr:season
    return
    <season>
        <name>{data($season_info/@name)}</name>
        <competition>
            <name>{data($season_info/sr:competition/@name)}</name>
            <gender>{data($season_info/sr:competition/@gender)}</gender>
        </competition>
        <date>
            <start>{data($season_info/@start_date)}</start>
            <end>{data($season_info/@end_date)}</end>
            <year>{data($season_info/@year)}</year>
        </date>
    </season>
};


declare function local:stages-xml() as node()* {
    for $stage in doc('../data/season_info.xml')//sr:stages//sr:stage
        return 
        <stage
            phase="{data($stage/@phase)}"
            start_date="{data($stage/@start_date)}"
            end_date="{data($stage/@end_date)}"
        >
            <groups>
                {local:groups-xml($stage)}
            </groups>
        </stage>
};

declare function local:groups-xml($stage as node()) as node()* {
    for $group in $stage/sr:groups/sr:group
    return 
    <group>
        {local:competitors-xml($group)}
    </group> 
};

declare function local:competitors-xml($group as node()) as node()* {
    for $competitor in $group/sr:competitors/sr:competitor
    return
    <competitor id="{$competitor/@id}">
        <name>{data($competitor/@name)}</name>
        <abbreviation>{data($competitor/@abbreviation)}</abbreviation>
    </competitor>
};


(:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~:)
(:~ COMPETITORS DATA (& PLAYERS) ~:)
(:~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~:)
declare function local:players-xml($competitor as node()*) as node()* {
    let $player-ids := distinct-values($competitor//sr:players/sr:player/@id)
    for $player-id in $player-ids
    let $player := $competitor//sr:players/sr:player[@id = $player-id]
    let $events_played := count($player[@played = 'true'])
    return
    <player id="{distinct-values($player/@id)}"> 
        <name>{distinct-values($player/@name)}</name>
        <type>{distinct-values($player/@type)}</type>
        <date_of_birth>{distinct-values($player/@date_of_birth)}</date_of_birth>
        <nationality>{distinct-values($player/@nationality)}</nationality>
        <events_played>{$events_played}</events_played>
    </player>
};

declare function local:competitors-xml() as node()* {
    let $competitor-ids := distinct-values(doc("../data/season_lineups.xml")//sr:competitors/sr:competitor/@id)
    for $competitor-id in $competitor-ids
    let $competitor := doc("../data/season_lineups.xml")//sr:competitors/sr:competitor[@id = $competitor-id]
    return
    <competitor id="{distinct-values($competitor/@id)}"> 
        <name>{distinct-values($competitor/@name)}</name>
        <players>{local:players-xml($competitor)}</players>
    </competitor>
};

(:~~~~~~~~~~~~~~:)
(:~ CREATE XML ~:)
(:~~~~~~~~~~~~~~:)

declare function local:create-xml() {
    <season_data>
        {local:season-xml()}
        <stages>
            {local:stages-xml()}
        </stages>

        <competitors>
            {local:competitors-xml()}
        </competitors>
    </season_data>
};

local:create-xml()
