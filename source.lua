local kyri = {}
local gs = cloneref or function(o) return o end

local function svc(n)
    return gs(game:GetService(n))
end

kyri.svc = {
    tw = svc("TweenService"),
    inp = svc("UserInputService"),
    plr = svc("Players"),
    gui = svc("GuiService"),
    run = svc("RunService"),
    http = svc("HttpService"),
    cas = svc("ContextActionService")
}

kyri.theme = {
    bg = Color3.fromRGB(8, 8, 10),
    container = Color3.fromRGB(14, 14, 18),
    element = Color3.fromRGB(20, 20, 26),
    hover = Color3.fromRGB(28, 28, 36),
    active = Color3.fromRGB(32, 32, 42),
    accent = Color3.fromRGB(138, 116, 249),
    text = Color3.fromRGB(245, 245, 250),
    subtext = Color3.fromRGB(165, 165, 180),
    border = Color3.fromRGB(32, 32, 40)
}

kyri.presets = {
    ["kyri"] = {
        bg = Color3.fromRGB(8,8,10), container = Color3.fromRGB(14,14,18),
        element = Color3.fromRGB(20,20,26), hover = Color3.fromRGB(28,28,36),
        active = Color3.fromRGB(32,32,42), accent = Color3.fromRGB(138,116,249),
        text = Color3.fromRGB(245,245,250), subtext = Color3.fromRGB(165,165,180),
        border = Color3.fromRGB(32,32,40),
    },
    ["midnight"] = {
        bg = Color3.fromRGB(6,8,14), container = Color3.fromRGB(10,14,22),
        element = Color3.fromRGB(16,20,32), hover = Color3.fromRGB(22,28,44),
        active = Color3.fromRGB(26,34,52), accent = Color3.fromRGB(80,160,255),
        text = Color3.fromRGB(240,245,255), subtext = Color3.fromRGB(140,160,200),
        border = Color3.fromRGB(24,32,50),
    },
    ["rose"] = {
        bg = Color3.fromRGB(12,8,10), container = Color3.fromRGB(18,12,16),
        element = Color3.fromRGB(26,18,22), hover = Color3.fromRGB(36,24,30),
        active = Color3.fromRGB(44,28,36), accent = Color3.fromRGB(255,110,150),
        text = Color3.fromRGB(255,245,248), subtext = Color3.fromRGB(190,160,170),
        border = Color3.fromRGB(40,26,32),
    },
    ["forest"] = {
        bg = Color3.fromRGB(8,12,8), container = Color3.fromRGB(12,18,12),
        element = Color3.fromRGB(18,26,18), hover = Color3.fromRGB(24,34,24),
        active = Color3.fromRGB(30,42,30), accent = Color3.fromRGB(80,220,120),
        text = Color3.fromRGB(240,250,240), subtext = Color3.fromRGB(150,190,155),
        border = Color3.fromRGB(24,38,24),
    },
    ["slate"] = {
        bg = Color3.fromRGB(12,12,14), container = Color3.fromRGB(18,18,22),
        element = Color3.fromRGB(26,26,32), hover = Color3.fromRGB(34,34,42),
        active = Color3.fromRGB(40,40,50), accent = Color3.fromRGB(160,160,185),
        text = Color3.fromRGB(240,240,245), subtext = Color3.fromRGB(160,160,175),
        border = Color3.fromRGB(36,36,44),
    },
}

-- LucideBlox icon pack (lucide.dev icons ported to Roblox asset IDs)
-- Usage: w:tab("Name", "icon-name") — e.g. "sword", "users", "settings-2"
kyri.icons = {
    ["CD"] = "rbxassetid://7734110220",
    ["activity"] = "rbxassetid://7733655755",
    ["airplay"] = "rbxassetid://7733655834",
    ["alarm-check"] = "rbxassetid://7733655912",
    ["alarm-clock-off"] = "rbxassetid://7733656003",
    ["alarm-clock"] = "rbxassetid://7733656100",
    ["alarm-minus"] = "rbxassetid://7733656164",
    ["alarm-plus"] = "rbxassetid://7733658066",
    ["album"] = "rbxassetid://7733658133",
    ["alert-circle"] = "rbxassetid://7733658271",
    ["alert-octagon"] = "rbxassetid://7733658335",
    ["alert-triangle"] = "rbxassetid://7733658504",
    ["align-center-horizontal"] = "rbxassetid://8997380477",
    ["align-center-vertical"] = "rbxassetid://8997380737",
    ["align-center"] = "rbxassetid://7733909776",
    ["align-end-horizontal"] = "rbxassetid://8997380820",
    ["align-end-vertical"] = "rbxassetid://8997380907",
    ["align-horizonal-distribute-center"] = "rbxassetid://8997381028",
    ["align-horizonal-distribute-end"] = "rbxassetid://8997381144",
    ["align-horizonal-distribute-start"] = "rbxassetid://8997381290",
    ["align-horizontal-justify-center"] = "rbxassetid://8997381461",
    ["align-horizontal-justify-end"] = "rbxassetid://8997381549",
    ["align-horizontal-justify-start"] = "rbxassetid://8997381652",
    ["align-horizontal-space-around"] = "rbxassetid://8997381738",
    ["align-horizontal-space-between"] = "rbxassetid://8997381854",
    ["align-justify"] = "rbxassetid://7733661326",
    ["align-left"] = "rbxassetid://7733911357",
    ["align-right"] = "rbxassetid://7733663582",
    ["align-start-horizontal"] = "rbxassetid://8997381965",
    ["align-start-vertical"] = "rbxassetid://8997382085",
    ["align-vertical-distribute-center"] = "rbxassetid://8997382212",
    ["align-vertical-distribute-end"] = "rbxassetid://8997382326",
    ["align-vertical-distribute-start"] = "rbxassetid://8997382428",
    ["align-vertical-justify-center"] = "rbxassetid://8997382502",
    ["align-vertical-justify-end"] = "rbxassetid://8997382584",
    ["align-vertical-justify-start"] = "rbxassetid://8997382639",
    ["align-vertical-space-around"] = "rbxassetid://8997382708",
    ["align-vertical-space-between"] = "rbxassetid://8997382793",
    ["anchor"] = "rbxassetid://7733911490",
    ["aperture"] = "rbxassetid://7733666258",
    ["archive"] = "rbxassetid://7733911621",
    ["arrow-big-down"] = "rbxassetid://7733668653",
    ["arrow-big-left"] = "rbxassetid://7733911731",
    ["arrow-big-right"] = "rbxassetid://7733671493",
    ["arrow-big-up"] = "rbxassetid://7733671663",
    ["arrow-down-circle"] = "rbxassetid://7733671763",
    ["arrow-down-left"] = "rbxassetid://7733672282",
    ["arrow-down-right"] = "rbxassetid://7733672831",
    ["arrow-down"] = "rbxassetid://7733672933",
    ["arrow-left-circle"] = "rbxassetid://7733673056",
    ["arrow-left-right"] = "rbxassetid://8997382869",
    ["arrow-left"] = "rbxassetid://7733673136",
    ["arrow-right-circle"] = "rbxassetid://7733673229",
    ["arrow-right"] = "rbxassetid://7733673345",
    ["arrow-up-circle"] = "rbxassetid://7733673466",
    ["arrow-up-left"] = "rbxassetid://7733673539",
    ["arrow-up-right"] = "rbxassetid://7733673646",
    ["arrow-up"] = "rbxassetid://7733673717",
    ["asterisk"] = "rbxassetid://7733673800",
    ["at-sign"] = "rbxassetid://7733673907",
    ["award"] = "rbxassetid://7733673987",
    ["axe"] = "rbxassetid://7733674079",
    ["banknote"] = "rbxassetid://7733674153",
    ["bar-chart-2"] = "rbxassetid://7733674239",
    ["bar-chart"] = "rbxassetid://7733674319",
    ["battery-charging"] = "rbxassetid://7733674402",
    ["battery-full"] = "rbxassetid://7733674503",
    ["battery-low"] = "rbxassetid://7733674589",
    ["battery-medium"] = "rbxassetid://7733674731",
    ["battery"] = "rbxassetid://7733674820",
    ["beaker"] = "rbxassetid://7733674922",
    ["bell-minus"] = "rbxassetid://7733675028",
    ["bell-off"] = "rbxassetid://7733675107",
    ["bell-plus"] = "rbxassetid://7733675181",
    ["bell-ring"] = "rbxassetid://7733675275",
    ["bell"] = "rbxassetid://7733911828",
    ["bike"] = "rbxassetid://7733678330",
    ["binary"] = "rbxassetid://7733678388",
    ["bluetooth-connected"] = "rbxassetid://7734110952",
    ["bluetooth-off"] = "rbxassetid://7733914252",
    ["bluetooth-searching"] = "rbxassetid://7733914320",
    ["bluetooth"] = "rbxassetid://7733687147",
    ["bold"] = "rbxassetid://7733687211",
    ["book-open"] = "rbxassetid://7733687281",
    ["book"] = "rbxassetid://7733914390",
    ["bookmark-minus"] = "rbxassetid://7733689754",
    ["bookmark-plus"] = "rbxassetid://7734111084",
    ["bookmark"] = "rbxassetid://7733692043",
    ["bot"] = "rbxassetid://7733916988",
    ["box-select"] = "rbxassetid://7733696665",
    ["box"] = "rbxassetid://7733917120",
    ["briefcase"] = "rbxassetid://7733919017",
    ["brush"] = "rbxassetid://7733701455",
    ["bug"] = "rbxassetid://7733701545",
    ["building"] = "rbxassetid://7733701625",
    ["bus"] = "rbxassetid://7733701715",
    ["calculator"] = "rbxassetid://7733919105",
    ["calendar"] = "rbxassetid://7733919198",
    ["camera-off"] = "rbxassetid://7733919260",
    ["camera"] = "rbxassetid://7733708692",
    ["car"] = "rbxassetid://7733708835",
    ["carrot"] = "rbxassetid://8997382987",
    ["cast"] = "rbxassetid://7733919326",
    ["charge"] = "rbxassetid://8997383136",
    ["check-circle-2"] = "rbxassetid://7733710700",
    ["check-circle"] = "rbxassetid://7733919427",
    ["check-square"] = "rbxassetid://7733919526",
    ["check"] = "rbxassetid://7733715400",
    ["chevron-down"] = "rbxassetid://7733717447",
    ["chevron-first"] = "rbxassetid://8997383275",
    ["chevron-last"] = "rbxassetid://8997383390",
    ["chevron-left"] = "rbxassetid://7733717651",
    ["chevron-right"] = "rbxassetid://7733717755",
    ["chevron-up"] = "rbxassetid://7733919605",
    ["chevrons-down-up"] = "rbxassetid://7733720483",
    ["chevrons-down"] = "rbxassetid://7733720604",
    ["chevrons-left"] = "rbxassetid://7733720701",
    ["chevrons-right"] = "rbxassetid://7733919682",
    ["chevrons-up-down"] = "rbxassetid://7733723321",
    ["chevrons-up"] = "rbxassetid://7733723433",
    ["chrome"] = "rbxassetid://7733919783",
    ["circle-slashed"] = "rbxassetid://8997383530",
    ["circle"] = "rbxassetid://7733919881",
    ["clipboard-check"] = "rbxassetid://7733919947",
    ["clipboard-copy"] = "rbxassetid://7733920037",
    ["clipboard-list"] = "rbxassetid://7733920117",
    ["clipboard-x"] = "rbxassetid://7733734668",
    ["clipboard"] = "rbxassetid://7733734762",
    ["clock-1"] = "rbxassetid://8997383694",
    ["clock-10"] = "rbxassetid://8997383876",
    ["clock-11"] = "rbxassetid://8997384034",
    ["clock-12"] = "rbxassetid://8997384150",
    ["clock-2"] = "rbxassetid://8997384295",
    ["clock-3"] = "rbxassetid://8997384456",
    ["clock-4"] = "rbxassetid://8997384603",
    ["clock-5"] = "rbxassetid://8997384798",
    ["clock-6"] = "rbxassetid://8997384977",
    ["clock-7"] = "rbxassetid://8997385147",
    ["clock-8"] = "rbxassetid://8997385352",
    ["clock-9"] = "rbxassetid://8997385485",
    ["clock"] = "rbxassetid://7733734848",
    ["cloud-drizzle"] = "rbxassetid://7733920226",
    ["cloud-fog"] = "rbxassetid://7733920317",
    ["cloud-hail"] = "rbxassetid://7733920444",
    ["cloud-lightning"] = "rbxassetid://7733741741",
    ["cloud-moon"] = "rbxassetid://7733920519",
    ["cloud-off"] = "rbxassetid://7733745572",
    ["cloud-rain-wind"] = "rbxassetid://7733746456",
    ["cloud-rain"] = "rbxassetid://7733746651",
    ["cloud-snow"] = "rbxassetid://7733746798",
    ["cloud-sun"] = "rbxassetid://7733746880",
    ["cloud"] = "rbxassetid://7733746980",
    ["cloudy"] = "rbxassetid://7733747106",
    ["clover"] = "rbxassetid://7733747233",
    ["code-2"] = "rbxassetid://7733920644",
    ["code"] = "rbxassetid://7733749837",
    ["codepen"] = "rbxassetid://7733920768",
    ["codesandbox"] = "rbxassetid://7733752575",
    ["coffee"] = "rbxassetid://7733752630",
    ["coins"] = "rbxassetid://7743866529",
    ["columns"] = "rbxassetid://7733757178",
    ["command"] = "rbxassetid://7733924046",
    ["compass"] = "rbxassetid://7733924216",
    ["contact"] = "rbxassetid://7743866666",
    ["contrast"] = "rbxassetid://7733764005",
    ["cookie"] = "rbxassetid://8997385628",
    ["copy"] = "rbxassetid://7733764083",
    ["copyleft"] = "rbxassetid://7733764196",
    ["copyright"] = "rbxassetid://7733764275",
    ["corner-down-left"] = "rbxassetid://7733764327",
    ["corner-down-right"] = "rbxassetid://7733764385",
    ["corner-left-down"] = "rbxassetid://7733764448",
    ["corner-left-up"] = "rbxassetid://7733764536",
    ["corner-right-down"] = "rbxassetid://7733764605",
    ["corner-right-up"] = "rbxassetid://7733764680",
    ["corner-up-left"] = "rbxassetid://7733764800",
    ["corner-up-right"] = "rbxassetid://7733764915",
    ["cpu"] = "rbxassetid://7733765045",
    ["crop"] = "rbxassetid://7733765140",
    ["cross"] = "rbxassetid://7733765224",
    ["crosshair"] = "rbxassetid://7733765307",
    ["crown"] = "rbxassetid://7733765398",
    ["currency"] = "rbxassetid://7733765592",
    ["database"] = "rbxassetid://7743866778",
    ["delete"] = "rbxassetid://7733768142",
    ["divide-circle"] = "rbxassetid://7733769152",
    ["divide-square"] = "rbxassetid://7733769261",
    ["divide"] = "rbxassetid://7733769365",
    ["dollar-sign"] = "rbxassetid://7733770599",
    ["download-cloud"] = "rbxassetid://7733770689",
    ["download"] = "rbxassetid://7733770755",
    ["dribbble"] = "rbxassetid://7733770843",
    ["droplet"] = "rbxassetid://7733770982",
    ["droplets"] = "rbxassetid://7733771078",
    ["drumstick"] = "rbxassetid://8997385789",
    ["edit-2"] = "rbxassetid://7733771217",
    ["edit-3"] = "rbxassetid://7733771361",
    ["edit"] = "rbxassetid://7733771472",
    ["egg"] = "rbxassetid://8997385940",
    ["electricity-off"] = "rbxassetid://7733771563",
    ["electricity"] = "rbxassetid://7733771628",
    ["equal-not"] = "rbxassetid://7733771726",
    ["equal"] = "rbxassetid://7733771811",
    ["euro"] = "rbxassetid://7733771891",
    ["expand"] = "rbxassetid://7733771982",
    ["external-link"] = "rbxassetid://7743866903",
    ["eye-off"] = "rbxassetid://7733774495",
    ["eye"] = "rbxassetid://7733774602",
    ["fast-forward"] = "rbxassetid://7743867090",
    ["feather"] = "rbxassetid://7733777166",
    ["figma"] = "rbxassetid://7743867310",
    ["file-check-2"] = "rbxassetid://7733779610",
    ["file-check"] = "rbxassetid://7733779668",
    ["file-code"] = "rbxassetid://7733779730",
    ["file-digit"] = "rbxassetid://7733935829",
    ["file-input"] = "rbxassetid://7733935917",
    ["file-minus-2"] = "rbxassetid://7733936010",
    ["file-minus"] = "rbxassetid://7733936115",
    ["file-output"] = "rbxassetid://7733788742",
    ["file-plus-2"] = "rbxassetid://7733788816",
    ["file-plus"] = "rbxassetid://7733788885",
    ["file-search"] = "rbxassetid://7733788966",
    ["file-text"] = "rbxassetid://7733789088",
    ["file-x-2"] = "rbxassetid://7743867554",
    ["file-x"] = "rbxassetid://7733938136",
    ["file"] = "rbxassetid://7733793319",
    ["files"] = "rbxassetid://7743867811",
    ["film"] = "rbxassetid://7733942579",
    ["filter"] = "rbxassetid://7733798407",
    ["flag-triangle-left"] = "rbxassetid://7733798509",
    ["flag-triangle-right"] = "rbxassetid://7733798634",
    ["flag"] = "rbxassetid://7733798691",
    ["flame"] = "rbxassetid://7733798747",
    ["flashlight-off"] = "rbxassetid://7733798799",
    ["flashlight"] = "rbxassetid://7733798851",
    ["flask-conical"] = "rbxassetid://7733798901",
    ["flask-round"] = "rbxassetid://7733798957",
    ["folder-minus"] = "rbxassetid://7733799022",
    ["folder-open"] = "rbxassetid://8997386062",
    ["folder-plus"] = "rbxassetid://7733799092",
    ["folder"] = "rbxassetid://7733799185",
    ["form-input"] = "rbxassetid://7733799275",
    ["forward"] = "rbxassetid://7733799371",
    ["framer"] = "rbxassetid://7733799486",
    ["frown"] = "rbxassetid://7733799591",
    ["function-square"] = "rbxassetid://7733799682",
    ["gamepad-2"] = "rbxassetid://7733799795",
    ["gamepad"] = "rbxassetid://7733799901",
    ["gauge"] = "rbxassetid://7733799969",
    ["gavel"] = "rbxassetid://7733800044",
    ["gem"] = "rbxassetid://7733942651",
    ["ghost"] = "rbxassetid://7743868000",
    ["gift-card"] = "rbxassetid://7733945018",
    ["gift"] = "rbxassetid://7733946818",
    ["git-branch-plus"] = "rbxassetid://7743868200",
    ["git-branch"] = "rbxassetid://7733949149",
    ["git-commit"] = "rbxassetid://7743868360",
    ["git-merge"] = "rbxassetid://7733952195",
    ["git-pull-request"] = "rbxassetid://7733952287",
    ["github"] = "rbxassetid://7733954058",
    ["gitlab"] = "rbxassetid://7733954246",
    ["glasses"] = "rbxassetid://7733954403",
    ["globe-2"] = "rbxassetid://7733954611",
    ["globe"] = "rbxassetid://7733954760",
    ["grab"] = "rbxassetid://7733954884",
    ["graduation-cap"] = "rbxassetid://7733955058",
    ["grid"] = "rbxassetid://7733955179",
    ["grip-horizontal"] = "rbxassetid://7733955302",
    ["grip-vertical"] = "rbxassetid://7733955410",
    ["hammer"] = "rbxassetid://7733955511",
    ["hand-metal"] = "rbxassetid://7733955664",
    ["hand"] = "rbxassetid://7733955740",
    ["hard-drive"] = "rbxassetid://7733955793",
    ["hard-hat"] = "rbxassetid://7733955850",
    ["hash"] = "rbxassetid://7733955906",
    ["haze"] = "rbxassetid://7733955969",
    ["headphones"] = "rbxassetid://7733956063",
    ["heart"] = "rbxassetid://7733956134",
    ["help-circle"] = "rbxassetid://7733956210",
    ["hexagon"] = "rbxassetid://7743868527",
    ["highlighter"] = "rbxassetid://7743868648",
    ["history"] = "rbxassetid://7733960880",
    ["home"] = "rbxassetid://7733960981",
    ["image-minus"] = "rbxassetid://7733963797",
    ["image-off"] = "rbxassetid://7733963907",
    ["image-plus"] = "rbxassetid://7733964016",
    ["image"] = "rbxassetid://7733964126",
    ["import"] = "rbxassetid://7733964240",
    ["inbox"] = "rbxassetid://7733964370",
    ["indent"] = "rbxassetid://7733964452",
    ["indian-rupee"] = "rbxassetid://7733964536",
    ["infinity"] = "rbxassetid://7733964640",
    ["info"] = "rbxassetid://7733964719",
    ["inspect"] = "rbxassetid://7733964808",
    ["italic"] = "rbxassetid://7733964917",
    ["jersey-pound"] = "rbxassetid://7733965029",
    ["key"] = "rbxassetid://7733965118",
    ["landmark"] = "rbxassetid://7733965184",
    ["languages"] = "rbxassetid://7733965249",
    ["laptop-2"] = "rbxassetid://7733965313",
    ["laptop"] = "rbxassetid://7733965386",
    ["lasso-select"] = "rbxassetid://7743868832",
    ["lasso"] = "rbxassetid://7733967892",
    ["layers"] = "rbxassetid://7743868936",
    ["layout-dashboard"] = "rbxassetid://7733970318",
    ["layout-grid"] = "rbxassetid://7733970390",
    ["layout-list"] = "rbxassetid://7733970442",
    ["layout-template"] = "rbxassetid://7733970494",
    ["layout"] = "rbxassetid://7733970543",
    ["library"] = "rbxassetid://7743869054",
    ["life-buoy"] = "rbxassetid://7733973479",
    ["lightbulb-off"] = "rbxassetid://7733975123",
    ["lightbulb"] = "rbxassetid://7733975185",
    ["link-2-off"] = "rbxassetid://7733975283",
    ["link-2"] = "rbxassetid://7743869163",
    ["link"] = "rbxassetid://7733978098",
    ["list-checks"] = "rbxassetid://7743869317",
    ["list-minus"] = "rbxassetid://7733980795",
    ["list-ordered"] = "rbxassetid://7743869411",
    ["list-plus"] = "rbxassetid://7733984995",
    ["list-x"] = "rbxassetid://7743869517",
    ["list"] = "rbxassetid://7743869612",
    ["loader-2"] = "rbxassetid://7733989869",
    ["loader"] = "rbxassetid://7733992358",
    ["locate-fixed"] = "rbxassetid://7733992424",
    ["locate"] = "rbxassetid://7733992469",
    ["lock"] = "rbxassetid://7733992528",
    ["log-in"] = "rbxassetid://7733992604",
    ["log-out"] = "rbxassetid://7733992677",
    ["mail"] = "rbxassetid://7733992732",
    ["map-pin"] = "rbxassetid://7733992789",
    ["map"] = "rbxassetid://7733992829",
    ["maximize-2"] = "rbxassetid://7733992901",
    ["maximize"] = "rbxassetid://7733992982",
    ["megaphone"] = "rbxassetid://7733993049",
    ["meh"] = "rbxassetid://7733993147",
    ["menu"] = "rbxassetid://7733993211",
    ["message-circle"] = "rbxassetid://7733993311",
    ["message-square"] = "rbxassetid://7733993369",
    ["mic-off"] = "rbxassetid://7743869714",
    ["mic"] = "rbxassetid://7743869805",
    ["minimize-2"] = "rbxassetid://7733997870",
    ["minimize"] = "rbxassetid://7733997941",
    ["minus-circle"] = "rbxassetid://7733998053",
    ["minus-square"] = "rbxassetid://7743869899",
    ["minus"] = "rbxassetid://7734000129",
    ["monitor-off"] = "rbxassetid://7734000184",
    ["monitor-speaker"] = "rbxassetid://7743869988",
    ["monitor"] = "rbxassetid://7734002839",
    ["moon"] = "rbxassetid://7743870134",
    ["more-horizontal"] = "rbxassetid://7734006080",
    ["more-vertical"] = "rbxassetid://7734006187",
    ["mountain-snow"] = "rbxassetid://7743870286",
    ["mountain"] = "rbxassetid://7734008868",
    ["mouse-pointer-2"] = "rbxassetid://7734010405",
    ["mouse-pointer-click"] = "rbxassetid://7734010488",
    ["mouse-pointer"] = "rbxassetid://7743870392",
    ["move-diagonal-2"] = "rbxassetid://7734013178",
    ["move-diagonal"] = "rbxassetid://7743870505",
    ["move-horizontal"] = "rbxassetid://7734016210",
    ["move-vertical"] = "rbxassetid://7743870608",
    ["move"] = "rbxassetid://7743870731",
    ["music"] = "rbxassetid://7734020554",
    ["navigation-2"] = "rbxassetid://7734020942",
    ["navigation"] = "rbxassetid://7734020989",
    ["network"] = "rbxassetid://7734021047",
    ["no_entry"] = "rbxassetid://7734021118",
    ["octagon"] = "rbxassetid://7734021165",
    ["on-charge"] = "rbxassetid://7734021231",
    ["option"] = "rbxassetid://7734021300",
    ["outdent"] = "rbxassetid://7734021384",
    ["package-check"] = "rbxassetid://8997386143",
    ["package-minus"] = "rbxassetid://8997386266",
    ["package-plus"] = "rbxassetid://8997386355",
    ["package-search"] = "rbxassetid://8997386448",
    ["package-x"] = "rbxassetid://8997386545",
    ["package"] = "rbxassetid://7734021469",
    ["palette"] = "rbxassetid://7734021595",
    ["paperclip"] = "rbxassetid://7734021680",
    ["pause-circle"] = "rbxassetid://7734021767",
    ["pause-octagon"] = "rbxassetid://7734021827",
    ["pause"] = "rbxassetid://7734021897",
    ["pen-tool"] = "rbxassetid://7734022041",
    ["pencil"] = "rbxassetid://7734022107",
    ["percent"] = "rbxassetid://7743870852",
    ["person-standing"] = "rbxassetid://7743871002",
    ["phone-call"] = "rbxassetid://7734027264",
    ["phone-forwarded"] = "rbxassetid://7734027345",
    ["phone-incoming"] = "rbxassetid://7743871120",
    ["phone-missed"] = "rbxassetid://7734029465",
    ["phone-off"] = "rbxassetid://7734029534",
    ["phone-outgoing"] = "rbxassetid://7743871253",
    ["phone"] = "rbxassetid://7734032056",
    ["pie-chart"] = "rbxassetid://7734034378",
    ["piggy-bank"] = "rbxassetid://7734034513",
    ["pin"] = "rbxassetid://8997386648",
    ["pipette"] = "rbxassetid://7743871384",
    ["plane"] = "rbxassetid://7734037723",
    ["play-circle"] = "rbxassetid://7734037784",
    ["play"] = "rbxassetid://7743871480",
    ["plus-circle"] = "rbxassetid://7734040271",
    ["plus-square"] = "rbxassetid://7734040369",
    ["plus"] = "rbxassetid://7734042071",
    ["pocket"] = "rbxassetid://7734042139",
    ["podcast"] = "rbxassetid://7734042234",
    ["pointer"] = "rbxassetid://7734042307",
    ["pound-sterling"] = "rbxassetid://7734042354",
    ["power-off"] = "rbxassetid://7734042423",
    ["power"] = "rbxassetid://7734042493",
    ["printer"] = "rbxassetid://7734042580",
    ["qr-code"] = "rbxassetid://7743871575",
    ["quote"] = "rbxassetid://7734045100",
    ["radio-receiver"] = "rbxassetid://7734045155",
    ["radio"] = "rbxassetid://7743871662",
    ["redo"] = "rbxassetid://7743871739",
    ["refresh-ccw"] = "rbxassetid://7734050715",
    ["refresh-cw"] = "rbxassetid://7734051052",
    ["regex"] = "rbxassetid://7734051188",
    ["repeat-1"] = "rbxassetid://7734051342",
    ["repeat"] = "rbxassetid://7734051454",
    ["reply-all"] = "rbxassetid://7734051524",
    ["reply"] = "rbxassetid://7734051594",
    ["rewind"] = "rbxassetid://7734051670",
    ["rocking-chair"] = "rbxassetid://7734051769",
    ["rotate-ccw"] = "rbxassetid://7734051861",
    ["rotate-cw"] = "rbxassetid://7734051957",
    ["rss"] = "rbxassetid://7734052075",
    ["ruler"] = "rbxassetid://7734052157",
    ["russian-ruble"] = "rbxassetid://7734052248",
    ["save"] = "rbxassetid://7734052335",
    ["scale"] = "rbxassetid://7734052454",
    ["scan-line"] = "rbxassetid://8997386772",
    ["scan"] = "rbxassetid://8997386861",
    ["scissors"] = "rbxassetid://7734052570",
    ["screen-share-off"] = "rbxassetid://7734052653",
    ["screen-share"] = "rbxassetid://7734052814",
    ["search"] = "rbxassetid://7734052925",
    ["send"] = "rbxassetid://7734053039",
    ["separator-horizontal"] = "rbxassetid://7734053146",
    ["separator-vertical"] = "rbxassetid://7734053213",
    ["server-crash"] = "rbxassetid://7734053281",
    ["server-off"] = "rbxassetid://7734053361",
    ["server"] = "rbxassetid://7734053426",
    ["settings-2"] = "rbxassetid://8997386997",
    ["settings"] = "rbxassetid://7734053495",
    ["share-2"] = "rbxassetid://7734053595",
    ["share"] = "rbxassetid://7734053697",
    ["sheet"] = "rbxassetid://7743871876",
    ["shield-alert"] = "rbxassetid://7734056326",
    ["shield-check"] = "rbxassetid://7734056411",
    ["shield-close"] = "rbxassetid://7734056470",
    ["shield-off"] = "rbxassetid://7734056540",
    ["shield"] = "rbxassetid://7734056608",
    ["shirt"] = "rbxassetid://7734056672",
    ["shopping-bag"] = "rbxassetid://7734056747",
    ["shopping-cart"] = "rbxassetid://7734056813",
    ["shovel"] = "rbxassetid://7734056878",
    ["shrink"] = "rbxassetid://7734056971",
    ["shuffle"] = "rbxassetid://7734057059",
    ["sidebar-close"] = "rbxassetid://7734058092",
    ["sidebar-open"] = "rbxassetid://7734058165",
    ["sidebar"] = "rbxassetid://7734058260",
    ["sigma"] = "rbxassetid://7734058345",
    ["signal-high"] = "rbxassetid://8997387110",
    ["signal-low"] = "rbxassetid://8997387189",
    ["signal-medium"] = "rbxassetid://8997387319",
    ["signal-zero"] = "rbxassetid://8997387434",
    ["signal"] = "rbxassetid://8997387546",
    ["skip-back"] = "rbxassetid://7734058404",
    ["skip-forward"] = "rbxassetid://7734058495",
    ["skull"] = "rbxassetid://7734058599",
    ["slash"] = "rbxassetid://8997387644",
    ["sliders"] = "rbxassetid://7734058803",
    ["smartphone-charging"] = "rbxassetid://7734058894",
    ["smartphone"] = "rbxassetid://7734058979",
    ["smile"] = "rbxassetid://7734059095",
    ["snowflake"] = "rbxassetid://7734059180",
    ["sort-asc"] = "rbxassetid://7734060715",
    ["sort-desc"] = "rbxassetid://7743871973",
    ["speaker"] = "rbxassetid://7734063416",
    ["sprout"] = "rbxassetid://7743872071",
    ["square"] = "rbxassetid://7743872181",
    ["star-half"] = "rbxassetid://7734068258",
    ["star"] = "rbxassetid://7734068321",
    ["stop-circle"] = "rbxassetid://7734068379",
    ["stretch-horizontal"] = "rbxassetid://8997387754",
    ["stretch-vertical"] = "rbxassetid://8997387862",
    ["strikethrough"] = "rbxassetid://7734068425",
    ["subscript"] = "rbxassetid://8997387937",
    ["sun"] = "rbxassetid://7734068495",
    ["sunrise"] = "rbxassetid://7743872365",
    ["sunset"] = "rbxassetid://7734070982",
    ["superscript"] = "rbxassetid://8997388036",
    ["swiss-franc"] = "rbxassetid://7734071038",
    ["switch-camera"] = "rbxassetid://7743872492",
    ["table"] = "rbxassetid://7734073253",
    ["tablet"] = "rbxassetid://7743872620",
    ["tag"] = "rbxassetid://7734075797",
    ["target"] = "rbxassetid://7743872758",
    ["tent"] = "rbxassetid://7734078943",
    ["terminal-square"] = "rbxassetid://7734079055",
    ["terminal"] = "rbxassetid://7743872929",
    ["text-cursor-input"] = "rbxassetid://8997388094",
    ["text-cursor"] = "rbxassetid://8997388195",
    ["thermometer-snowflake"] = "rbxassetid://7743873074",
    ["thermometer-sun"] = "rbxassetid://7734084018",
    ["thermometer"] = "rbxassetid://7734084149",
    ["thumbs-down"] = "rbxassetid://7734084236",
    ["thumbs-up"] = "rbxassetid://7743873212",
    ["ticket"] = "rbxassetid://7734086558",
    ["timer-off"] = "rbxassetid://8997388325",
    ["timer-reset"] = "rbxassetid://7743873336",
    ["timer"] = "rbxassetid://7743873443",
    ["toggle-left"] = "rbxassetid://7734091286",
    ["toggle-right"] = "rbxassetid://7743873539",
    ["tornado"] = "rbxassetid://7743873633",
    ["trash-2"] = "rbxassetid://7743873772",
    ["trash"] = "rbxassetid://7743873871",
    ["trello"] = "rbxassetid://7743873996",
    ["trending-down"] = "rbxassetid://7743874143",
    ["trending-up"] = "rbxassetid://7743874262",
    ["triangle"] = "rbxassetid://7743874367",
    ["truck"] = "rbxassetid://7743874482",
    ["tv-2"] = "rbxassetid://7743874599",
    ["tv"] = "rbxassetid://7743874674",
    ["type"] = "rbxassetid://7743874740",
    ["umbrella"] = "rbxassetid://7743874820",
    ["underline"] = "rbxassetid://7743874904",
    ["undo"] = "rbxassetid://7743874974",
    ["unlink-2"] = "rbxassetid://7743875069",
    ["unlink"] = "rbxassetid://7743875149",
    ["unlock"] = "rbxassetid://7743875263",
    ["upload-cloud"] = "rbxassetid://7743875358",
    ["upload"] = "rbxassetid://7743875428",
    ["user-check"] = "rbxassetid://7743875503",
    ["user-minus"] = "rbxassetid://7743875629",
    ["user-plus"] = "rbxassetid://7743875759",
    ["user-x"] = "rbxassetid://7743875879",
    ["user"] = "rbxassetid://7743875962",
    ["users"] = "rbxassetid://7743876054",
    ["verified"] = "rbxassetid://7743876142",
    ["vibrate"] = "rbxassetid://7743876302",
    ["video-off"] = "rbxassetid://7743876466",
    ["video"] = "rbxassetid://7743876610",
    ["view"] = "rbxassetid://7743876754",
    ["voicemail"] = "rbxassetid://7743876916",
    ["volume-1"] = "rbxassetid://7743877081",
    ["volume-2"] = "rbxassetid://7743877250",
    ["volume-x"] = "rbxassetid://7743877381",
    ["volume"] = "rbxassetid://7743877487",
    ["wallet"] = "rbxassetid://7743877573",
    ["wand"] = "rbxassetid://8997388430",
    ["watch"] = "rbxassetid://7743877668",
    ["webcam"] = "rbxassetid://7743877896",
    ["wifi-off"] = "rbxassetid://7743878056",
    ["wifi"] = "rbxassetid://7743878148",
    ["wind"] = "rbxassetid://7743878264",
    ["wrap-text"] = "rbxassetid://8997388548",
    ["wrench"] = "rbxassetid://7743878358",
    ["x-circle"] = "rbxassetid://7743878496",
    ["x-octagon"] = "rbxassetid://7743878618",
    ["x-square"] = "rbxassetid://7743878737",
    ["x"] = "rbxassetid://7743878857",
    ["zoom-in"] = "rbxassetid://7743878977",
    ["zoom-out"] = "rbxassetid://7743879082",
    -- legacy aliases kept for backwards compatibility
    ["sword"] = "rbxassetid://7733674079",
    ["move"] = "rbxassetid://7743870731",
}

local function make(c, p)
    local o = Instance.new(c)
    for k, v in pairs(p) do
        o[k] = v
    end
    if o:IsA("GuiObject") then
        o.BorderSizePixel = 0
    end
    return o
end

local CONFIG_FOLDER = "KyriLib"

local function encode_val(v)
    if typeof(v) == "Color3" then
        return {__type = "Color3", r = v.R, g = v.G, b = v.B}
    end
    return v
end

local function decode_val(v)
    if type(v) == "table" and v.__type == "Color3" then
        return Color3.new(v.r, v.g, v.b)
    end
    return v
end

local function save_config(game_name, config_name, data)
    local path = CONFIG_FOLDER .. "/" .. game_name
    if not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end
    if not isfolder(path) then makefolder(path) end
    local encoded = {}
    for k, v in pairs(data) do encoded[k] = encode_val(v) end
    writefile(path .. "/" .. config_name .. ".json", kyri.svc.http:JSONEncode(encoded))
end

local function load_config(game_name, config_name)
    local path = CONFIG_FOLDER .. "/" .. game_name .. "/" .. config_name .. ".json"
    if isfile(path) then
        local raw = kyri.svc.http:JSONDecode(readfile(path))
        local out = {}
        for k, v in pairs(raw) do out[k] = decode_val(v) end
        return out
    end
    return nil
end

local function list_configs(game_name)
    local path = CONFIG_FOLDER .. "/" .. game_name
    if not isfolder(path) then return {} end
    local files = listfiles(path)
    local configs = {}
    for _, file in ipairs(files) do
        local name = file:match("([^/\\]+)%.json$")
        if name then table.insert(configs, name) end
    end
    return configs
end

local function delete_config(game_name, config_name)
    local path = CONFIG_FOLDER .. "/" .. game_name .. "/" .. config_name .. ".json"
    if isfile(path) then delfile(path) end
end

function kyri.new(title, options)
    options = options or {}

    if getgenv then
        if getgenv().__kyri_inst then
            pcall(function() getgenv().__kyri_inst:destroy() end)
            getgenv().__kyri_inst = nil
        end
    end

    local localPlayer = kyri.svc.plr.LocalPlayer

    local existing = localPlayer.PlayerGui:FindFirstChild("Kyri")
    if existing then existing:Destroy() end

    local load_gui = make("ScreenGui", {
        Name = "KyriLoad",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 999999999,
        Parent = localPlayer.PlayerGui
    })

    local logo = make("ImageLabel", {
        Size = UDim2.fromOffset(300, 300),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "",
        ImageTransparency = 1,
        Parent = load_gui
    })

    local loaded = false

    task.spawn(function()
        local url = "https://raw.githubusercontent.com/Justanewplayer19/KyriLib/refs/heads/main/kyriliblogo.png"
        local path = "kyrilib_logo.png"

        if not isfile(path) then
            local success, data = pcall(function()
                return game:HttpGet(url)
            end)
            if success then writefile(path, data) end
        end

        if isfile(path) then
            logo.Image = getcustomasset(path)
        end

        kyri.svc.tw:Create(logo, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
        task.wait(3)
        kyri.svc.tw:Create(logo, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
        task.wait(0.5)
        load_gui:Destroy()
        loaded = true
    end)

    repeat task.wait() until loaded

    -- Key system
    if options.KeySystem then
        local ks = options.KeySettings or {}
        local validKeys = ks.Key or {}
        local fileName = ks.FileName and (ks.FileName .. "_kyrikey.txt")
        local saveKey = ks.SaveKey ~= false
        local th = kyri.theme

        local savedKeyValid = false
        if saveKey and fileName then
            pcall(function()
                if isfile(fileName) then
                    local saved = readfile(fileName)
                    for _, k in ipairs(validKeys) do
                        if saved == k then savedKeyValid = true break end
                    end
                end
            end)
        end

        if not savedKeyValid then
            local keyGui = make("ScreenGui", {
                Name = "KyriKey",
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
                ResetOnSpawn = false,
                IgnoreGuiInset = true,
                DisplayOrder = 999999999,
                Parent = localPlayer.PlayerGui
            })

            make("Frame", {
                Size = UDim2.fromScale(1, 1),
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                BackgroundTransparency = 0.45,
                Parent = keyGui
            })

            local dialog = make("Frame", {
                Size = UDim2.fromOffset(420, 210),
                Position = UDim2.new(0.5, -210, 0.5, -105),
                BackgroundColor3 = th.bg,
                ClipsDescendants = true,
                Parent = keyGui
            })
            make("UICorner", { CornerRadius = UDim.new(0, 12), Parent = dialog })
            make("UIStroke", { Color = th.border, Thickness = 1, Parent = dialog })

            make("TextLabel", {
                Size = UDim2.new(1, -60, 0, 28),
                Position = UDim2.fromOffset(20, 18),
                BackgroundTransparency = 1,
                Text = ks.Title or "Key System",
                TextColor3 = th.text,
                TextSize = 16,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = dialog
            })

            make("TextLabel", {
                Size = UDim2.new(1, -60, 0, 18),
                Position = UDim2.fromOffset(20, 44),
                BackgroundTransparency = 1,
                Text = ks.Subtitle or "Enter your key to continue",
                TextColor3 = th.subtext,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = dialog
            })

            local closeBtn = make("TextButton", {
                Size = UDim2.fromOffset(30, 30),
                Position = UDim2.new(1, -38, 0, 8),
                BackgroundTransparency = 1,
                Text = "×",
                TextColor3 = th.subtext,
                TextSize = 22,
                Font = Enum.Font.GothamBold,
                Parent = dialog
            })

            -- left side: key input
            make("TextLabel", {
                Size = UDim2.new(0.5, -30, 0, 16),
                Position = UDim2.fromOffset(20, 80),
                BackgroundTransparency = 1,
                Text = "Key",
                TextColor3 = th.subtext,
                TextSize = 11,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = dialog
            })

            local keyBox = make("Frame", {
                Size = UDim2.new(0.52, 0, 0, 36),
                Position = UDim2.fromOffset(20, 98),
                BackgroundColor3 = th.element,
                Parent = dialog
            })
            make("UICorner", { CornerRadius = UDim.new(0, 8), Parent = keyBox })
            make("UIStroke", { Color = th.border, Thickness = 1, Parent = keyBox })

            local keyInput = make("TextBox", {
                Size = UDim2.new(1, -16, 1, 0),
                Position = UDim2.fromOffset(8, 0),
                BackgroundTransparency = 1,
                Text = "",
                PlaceholderText = "key",
                TextColor3 = th.text,
                PlaceholderColor3 = th.subtext,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                ClearTextOnFocus = false,
                Parent = keyBox
            })

            -- right side: note
            if ks.Note then
                make("TextLabel", {
                    Size = UDim2.new(0.44, -10, 0, 16),
                    Position = UDim2.new(0.55, 0, 0, 80),
                    BackgroundTransparency = 1,
                    Text = "Note",
                    TextColor3 = th.subtext,
                    TextSize = 11,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = dialog
                })
                make("TextLabel", {
                    Size = UDim2.new(0.44, -10, 0, 70),
                    Position = UDim2.new(0.55, 0, 0, 98),
                    BackgroundTransparency = 1,
                    Text = ks.Note,
                    TextColor3 = th.text,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    Parent = dialog
                })
            end

            local submitBtn = make("TextButton", {
                Size = UDim2.new(0.52, 0, 0, 32),
                Position = UDim2.fromOffset(20, 148),
                BackgroundColor3 = th.accent,
                Text = "Submit",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                Parent = dialog
            })
            make("UICorner", { CornerRadius = UDim.new(0, 8), Parent = submitBtn })

            local errLabel = make("TextLabel", {
                Size = UDim2.new(0.52, 0, 0, 18),
                Position = UDim2.fromOffset(20, 183),
                BackgroundTransparency = 1,
                Text = "",
                TextColor3 = Color3.fromRGB(255, 80, 80),
                TextSize = 11,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = dialog
            })

            local keyDone = false
            local keyAccepted = false

            local function tryKey(input)
                local trimmed = input:match("^%s*(.-)%s*$")
                for _, k in ipairs(validKeys) do
                    if trimmed == k then return true, trimmed end
                end
                return false
            end

            submitBtn.MouseButton1Click:Connect(function()
                local ok, trimmed = tryKey(keyInput.Text)
                if ok then
                    if saveKey and fileName then
                        pcall(function() writefile(fileName, trimmed) end)
                    end
                    keyAccepted = true
                    keyDone = true
                else
                    errLabel.Text = "invalid key"
                    keyInput.Text = ""
                end
            end)

            closeBtn.MouseButton1Click:Connect(function()
                keyDone = true
            end)

            repeat task.wait() until keyDone
            keyGui:Destroy()

            if not keyAccepted then return end
        end

        -- Success splash
        local splashGui = make("ScreenGui", {
            Name = "KyriKeySplash",
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            ResetOnSpawn = false,
            IgnoreGuiInset = true,
            DisplayOrder = 999999999,
            Parent = localPlayer.PlayerGui
        })

        local splashBg = make("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.fromRGB(10, 10, 12),
            BackgroundTransparency = 0,
            Parent = splashGui
        })

        local splashTitle = make("TextLabel", {
            Size = UDim2.new(1, -40, 0, 36),
            Position = UDim2.new(0, 30, 0.44, 0),
            BackgroundTransparency = 1,
            Text = ks.Title or title or "Key System",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextTransparency = 0,
            TextSize = 22,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = splashBg
        })

        local splashSub = make("TextLabel", {
            Size = UDim2.new(1, -40, 0, 22),
            Position = UDim2.new(0, 30, 0.44, 40),
            BackgroundTransparency = 1,
            Text = "by " .. (ks.Creator or "you"),
            TextColor3 = Color3.fromRGB(160, 160, 175),
            TextTransparency = 0,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = splashBg
        })

        local splashBrand = make("TextLabel", {
            Size = UDim2.new(1, -20, 0, 20),
            Position = UDim2.new(0, 0, 1, -30),
            BackgroundTransparency = 1,
            Text = "Kyri UI",
            TextColor3 = Color3.fromRGB(70, 70, 80),
            TextTransparency = 0,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = splashBg
        })

        task.wait(2)

        local fadeInfo = TweenInfo.new(0.5)
        kyri.svc.tw:Create(splashBg, fadeInfo, { BackgroundTransparency = 1 }):Play()
        kyri.svc.tw:Create(splashTitle, fadeInfo, { TextTransparency = 1 }):Play()
        kyri.svc.tw:Create(splashSub, fadeInfo, { TextTransparency = 1 }):Play()
        kyri.svc.tw:Create(splashBrand, fadeInfo, { TextTransparency = 1 }):Play()
        task.wait(0.6)
        splashGui:Destroy()
    end

    local w = {}
    local conns = {}

    w.title = title or "kyri"
    w.tabs = {}
    w.active = nil
    w.accents = {}
    w.sounds = {}
    w.flags = {}
    w.game_name = options.GameName or "Default"
    w.is_mobile = kyri.svc.inp.TouchEnabled and not kyri.svc.inp.KeyboardEnabled

    local t = {
        bg = (options.Theme and options.Theme.bg) or kyri.theme.bg,
        container = (options.Theme and options.Theme.container) or kyri.theme.container,
        element = (options.Theme and options.Theme.element) or kyri.theme.element,
        hover = (options.Theme and options.Theme.hover) or kyri.theme.hover,
        active = (options.Theme and options.Theme.active) or kyri.theme.active,
        accent = (options.Theme and options.Theme.accent) or kyri.theme.accent,
        text = (options.Theme and options.Theme.text) or kyri.theme.text,
        subtext = (options.Theme and options.Theme.subtext) or kyri.theme.subtext,
        border = (options.Theme and options.Theme.border) or kyri.theme.border
    }

    w.gui = make("ScreenGui", {
        Name = "Kyri",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 999999999
    })

    local sound_ids = {
        click = "rbxassetid://7249904928",
        hover = "rbxassetid://7249903719",
        toggle_on = "rbxassetid://6026984224",
        toggle_off = "rbxassetid://6026984224"
    }

    for name, id in pairs(sound_ids) do
        w.sounds[name] = make("Sound", {
            SoundId = id,
            Volume = 0.3,
            Parent = w.gui
        })
    end

    local function play(name)
        if w.sounds[name] then w.sounds[name]:Play() end
    end

    local main = make("Frame", {
        Name = "Main",
        Size = UDim2.fromOffset(520, 400),
        Position = UDim2.new(0.5, -260, 0.5, -200),
        BackgroundColor3 = t.bg,
        ClipsDescendants = true,
        Visible = not w.is_mobile,
        Parent = w.gui
    })

    make("UICorner", {CornerRadius = UDim.new(0, 12), Parent = main})

    local resize_handle = make("ImageButton", {
        Size = UDim2.fromOffset(20, 20),
        Position = UDim2.fromScale(1, 1),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6023426962",
        ImageColor3 = t.subtext,
        ZIndex = 100,
        Visible = not w.is_mobile,
        Parent = main
    })

    local minimized = false
    local pre_min_size = nil
    local sidebar, content

    if not w.is_mobile then
        local resizing = false
        local resize_start = nil
        local size_start = nil
        local min_size = Vector2.new(400, 300)

        resize_handle.InputBegan:Connect(function(inp)
            if minimized then return end
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = true
                resize_start = inp.Position
                size_start = main.Size
            end
        end)

        table.insert(conns, kyri.svc.inp.InputChanged:Connect(function(inp)
            if resizing and inp.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = inp.Position - resize_start
                local new_x = math.max(size_start.X.Offset + delta.X, min_size.X)
                local new_y = math.max(size_start.Y.Offset + delta.Y, min_size.Y)
                main.Size = UDim2.fromOffset(new_x, new_y)
            end
        end))

        table.insert(conns, kyri.svc.inp.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = false
            end
        end))

        resize_handle.MouseEnter:Connect(function()
            kyri.svc.tw:Create(resize_handle, TweenInfo.new(0.2), {ImageColor3 = t.text}):Play()
        end)
        resize_handle.MouseLeave:Connect(function()
            kyri.svc.tw:Create(resize_handle, TweenInfo.new(0.2), {ImageColor3 = t.subtext}):Play()
        end)
    end

    local glow = make("ImageLabel", {
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = t.accent,
        ImageTransparency = 0.85,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        Parent = main
    })

    table.insert(w.accents, {obj = glow, prop = "ImageColor3"})

    local top = make("Frame", {
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = t.container,
        Parent = main
    })

    make("UICorner", {CornerRadius = UDim.new(0, 12), Parent = top})

    make("Frame", {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = t.container,
        BorderSizePixel = 0,
        Parent = top
    })

    make("TextLabel", {
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.fromOffset(20, 0),
        BackgroundTransparency = 1,
        Text = w.title,
        TextColor3 = t.text,
        Font = Enum.Font.GothamBold,
        TextSize = 17,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = top
    })

    local accent_bar = make("Frame", {
        Size = UDim2.new(0, 3, 0, 24),
        Position = UDim2.fromOffset(8, 14),
        BackgroundColor3 = t.accent,
        BorderSizePixel = 0,
        Parent = top
    })

    table.insert(w.accents, {obj = accent_bar, prop = "BackgroundColor3"})
    make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = accent_bar})

    local minimize = make("ImageButton", {
        Size = UDim2.fromOffset(18, 18),
        Position = UDim2.new(1, -15, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6026568240",
        ImageColor3 = t.subtext,
        Parent = top
    })

    minimize.MouseEnter:Connect(function()
        play("hover")
        kyri.svc.tw:Create(minimize, TweenInfo.new(0.2), {ImageColor3 = t.text}):Play()
    end)
    minimize.MouseLeave:Connect(function()
        kyri.svc.tw:Create(minimize, TweenInfo.new(0.2), {ImageColor3 = t.subtext}):Play()
    end)

    minimize.MouseButton1Click:Connect(function()
        play("click")
        minimized = not minimized

        if minimized then
            pre_min_size = main.Size
            sidebar.Visible = false
            content.Visible = false
            kyri.svc.tw:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, main.Size.X.Offset, 0, 52)
            }):Play()
        else
            kyri.svc.tw:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                Size = pre_min_size
            }):Play()
            task.delay(0.25, function()
                if not minimized then
                    sidebar.Visible = true
                    content.Visible = true
                end
            end)
        end

        kyri.svc.tw:Create(minimize, TweenInfo.new(0.25), {
            Rotation = minimized and 180 or 0
        }):Play()
    end)

    sidebar = make("Frame", {
        Size = UDim2.new(0, 140, 1, -64),
        Position = UDim2.fromOffset(12, 58),
        BackgroundTransparency = 1,
        Parent = main
    })

    local tab_holder = make("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Parent = sidebar
    })

    local tab_list = make("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tab_holder
    })

    tab_list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab_holder.CanvasSize = UDim2.new(0, 0, 0, tab_list.AbsoluteContentSize.Y)
    end)

    content = make("Frame", {
        Size = UDim2.new(1, -168, 1, -70),
        Position = UDim2.fromOffset(158, 58),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = main
    })

    local drag, drag_input, drag_start, input_start = false, nil, nil, nil

    local function update_input(input)
        local delta = input.Position - drag_start
        local position = UDim2.new(
            input_start.X.Scale,
            input_start.X.Offset + delta.X,
            input_start.Y.Scale,
            input_start.Y.Offset + delta.Y
        )
        kyri.svc.tw:Create(main, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = position
        }):Play()
    end

    top.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or (w.is_mobile and inp.UserInputType == Enum.UserInputType.Touch) then
            drag = true
            drag_start = inp.Position
            input_start = main.Position
            drag_input = inp

            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then
                    drag = false
                end
            end)
        end
    end)

    top.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseMovement or (w.is_mobile and inp.UserInputType == Enum.UserInputType.Touch) then
            drag_input = inp
        end
    end)

    table.insert(conns, kyri.svc.run.Heartbeat:Connect(function()
        if drag and drag_input then update_input(drag_input) end
    end))

    w.gui.Parent = localPlayer.PlayerGui
    w.localPlayer = localPlayer

    local function toggle_gui()
        main.Visible = not main.Visible
    end

    if w.is_mobile then
        kyri.svc.cas:BindAction("KyriToggle", function(name, state, input)
            if state == Enum.UserInputState.Begin then toggle_gui() end
        end, true, Enum.KeyCode.ButtonR3)
        kyri.svc.cas:SetTitle("KyriToggle", "Kyri")
        kyri.svc.cas:SetPosition("KyriToggle", UDim2.new(1, -70, 1, -70))
    else
        table.insert(conns, kyri.svc.inp.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == Enum.KeyCode.RightControl then toggle_gui() end
        end))
    end

    local function make_colorpicker_popup(current, on_change)
        local popup_gui = make("ScreenGui", {
            Name = "KyriColorPicker",
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            ResetOnSpawn = false,
            IgnoreGuiInset = true,
            DisplayOrder = 1000000001,
            Parent = localPlayer.PlayerGui
        })

        local overlay = make("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Parent = popup_gui
        })

        local picker = make("Frame", {
            Size = UDim2.fromOffset(260, 230),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = t.bg,
            Parent = overlay
        })
        make("UICorner", {CornerRadius = UDim.new(0, 10), Parent = picker})

        local h, s, v = Color3.toHSV(current)

        local sv_frame = make("ImageLabel", {
            Size = UDim2.fromOffset(220, 140),
            Position = UDim2.fromOffset(20, 16),
            BackgroundColor3 = Color3.fromHSV(h, 1, 1),
            Image = "rbxassetid://4155801252",
            Parent = picker
        })
        make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = sv_frame})

        local sv_cursor = make("Frame", {
            Size = UDim2.fromOffset(10, 10),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(s, 0, 1 - v, 0),
            BackgroundColor3 = Color3.new(1, 1, 1),
            ZIndex = 2,
            Parent = sv_frame
        })
        make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = sv_cursor})

        local hue_bar = make("ImageLabel", {
            Size = UDim2.fromOffset(220, 14),
            Position = UDim2.fromOffset(20, 164),
            Image = "rbxassetid://698052001",
            Parent = picker
        })
        make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = hue_bar})

        local hue_cursor = make("Frame", {
            Size = UDim2.fromOffset(10, 14),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(h, 0, 0.5, 0),
            BackgroundColor3 = Color3.new(1, 1, 1),
            ZIndex = 2,
            Parent = hue_bar
        })
        make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = hue_cursor})

        local preview = make("Frame", {
            Size = UDim2.fromOffset(40, 24),
            Position = UDim2.fromOffset(20, 188),
            BackgroundColor3 = current,
            Parent = picker
        })
        make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = preview})

        local done_btn = make("TextButton", {
            Size = UDim2.fromOffset(100, 24),
            Position = UDim2.new(1, -20, 1, -12),
            AnchorPoint = Vector2.new(1, 1),
            BackgroundColor3 = t.element,
            Text = "done",
            TextColor3 = t.text,
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            AutoButtonColor = false,
            Parent = picker
        })
        make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = done_btn})

        local function refresh()
            local c = Color3.fromHSV(h, s, v)
            sv_frame.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            sv_cursor.Position = UDim2.new(s, 0, 1 - v, 0)
            hue_cursor.Position = UDim2.new(h, 0, 0.5, 0)
            preview.BackgroundColor3 = c
            if on_change then on_change(c) end
        end

        local dragging_sv = false
        local dragging_hue = false

        sv_frame.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging_sv = true
                s = math.clamp((inp.Position.X - sv_frame.AbsolutePosition.X) / sv_frame.AbsoluteSize.X, 0, 1)
                v = 1 - math.clamp((inp.Position.Y - sv_frame.AbsolutePosition.Y) / sv_frame.AbsoluteSize.Y, 0, 1)
                refresh()
            end
        end)

        hue_bar.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging_hue = true
                h = math.clamp((inp.Position.X - hue_bar.AbsolutePosition.X) / hue_bar.AbsoluteSize.X, 0, 1)
                refresh()
            end
        end)

        local pc_conn = kyri.svc.inp.InputChanged:Connect(function(inp)
            if inp.UserInputType ~= Enum.UserInputType.MouseMovement then return end
            if dragging_sv then
                s = math.clamp((inp.Position.X - sv_frame.AbsolutePosition.X) / sv_frame.AbsoluteSize.X, 0, 1)
                v = 1 - math.clamp((inp.Position.Y - sv_frame.AbsolutePosition.Y) / sv_frame.AbsoluteSize.Y, 0, 1)
                refresh()
            elseif dragging_hue then
                h = math.clamp((inp.Position.X - hue_bar.AbsolutePosition.X) / hue_bar.AbsoluteSize.X, 0, 1)
                refresh()
            end
        end)

        local pe_conn = kyri.svc.inp.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging_sv = false
                dragging_hue = false
            end
        end)

        overlay.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                local pos = inp.Position
                local ap = picker.AbsolutePosition
                local as = picker.AbsoluteSize
                if pos.X < ap.X or pos.X > ap.X + as.X or pos.Y < ap.Y or pos.Y > ap.Y + as.Y then
                    pc_conn:Disconnect()
                    pe_conn:Disconnect()
                    popup_gui:Destroy()
                end
            end
        end)

        done_btn.MouseButton1Click:Connect(function()
            pc_conn:Disconnect()
            pe_conn:Disconnect()
            popup_gui:Destroy()
        end)
    end

    function w:tab(name, icon)
        local tab = {}
        tab.name = name
        tab.elements = {}

        local btn = make("TextButton", {
            Name = name,
            Size = UDim2.new(1, 0, 0, 38),
            BackgroundColor3 = t.element,
            Text = "",
            AutoButtonColor = false,
            Parent = tab_holder
        })
        make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = btn})

        local has_icon = icon ~= nil
        local text_offset = has_icon and 36 or 12

        if has_icon then
            local icon_id = kyri.icons[icon]
                or (type(icon) == "string" and (icon:find("^rbxassetid://") or icon:find("^rbxthumb://")) and icon)
                or "rbxassetid://7743875962"

            local icon_img = make("ImageLabel", {
                Size = UDim2.fromOffset(18, 18),
                Position = UDim2.fromOffset(11, 10),
                BackgroundTransparency = 1,
                Image = icon_id,
                ImageColor3 = t.subtext,
                Parent = btn
            })
            tab.icon = icon_img

            -- download https:// icons via executor request() + getcustomasset()
            if type(icon) == "string" and icon:find("^https://") then
                task.spawn(function()
                    local ok, err = pcall(function()
                        local http = request or http_request or syn and syn.request
                        if not http then return end
                        local res = http({ Url = icon, Method = "GET" })
                        if not res or res.StatusCode ~= 200 or not res.Body then return end
                        if not getcustomasset then return end
                        -- derive a stable filename from the url so the same icon isn't re-downloaded every tab switch
                        local fname = "kyrilib_icons/" .. icon:gsub("[^%w]", "_"):sub(1, 64) .. ".png"
                        if not isfolder("kyrilib_icons") then makefolder("kyrilib_icons") end
                        writefile(fname, res.Body)
                        local asset = getcustomasset(fname)
                        icon_img.Image = asset
                    end)
                    if not ok then
                        -- silently fail — icon stays as default
                    end
                end)
            end
        end

        local txt = make("TextLabel", {
            Size = UDim2.new(1, -text_offset - 12, 1, 0),
            Position = UDim2.fromOffset(text_offset, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = t.subtext,
            Font = Enum.Font.GothamMedium,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = btn
        })

        local indicator = make("Frame", {
            Size = UDim2.new(0, 0, 0, 38),
            Position = UDim2.new(1, 0, 0, 0),
            BackgroundColor3 = t.accent,
            BorderSizePixel = 0,
            Parent = btn
        })
        table.insert(w.accents, {obj = indicator, prop = "BackgroundColor3"})
        make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = indicator})

        local page = make("ScrollingFrame", {
            Name = name,
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = t.accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = content
        })
        table.insert(w.accents, {obj = page, prop = "ScrollBarImageColor3"})

        local page_list = make("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = page
        })

        make("UIPadding", {
            PaddingTop = UDim.new(0, 4),
            PaddingBottom = UDim.new(0, 8),
            Parent = page
        })

        page_list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, page_list.AbsoluteContentSize.Y + 12)
        end)

        local ti = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        btn.MouseButton1Click:Connect(function()
            play("click")

            for _, tb in pairs(w.tabs) do
                tb.page.Visible = false
                kyri.svc.tw:Create(tb.btn, ti, {BackgroundColor3 = t.element}):Play()
                kyri.svc.tw:Create(tb.txt, ti, {TextColor3 = t.subtext}):Play()
                kyri.svc.tw:Create(tb.indicator, ti, {Size = UDim2.new(0, 0, 0, 38)}):Play()
                if tb.icon then
                    kyri.svc.tw:Create(tb.icon, ti, {ImageColor3 = t.subtext}):Play()
                end
            end

            page.Visible = true
            kyri.svc.tw:Create(btn, ti, {BackgroundColor3 = t.hover}):Play()
            kyri.svc.tw:Create(txt, ti, {TextColor3 = t.text}):Play()
            kyri.svc.tw:Create(indicator, ti, {Size = UDim2.new(0, 3, 0, 38)}):Play()
            if tab.icon then
                kyri.svc.tw:Create(tab.icon, ti, {ImageColor3 = t.text}):Play()
            end
            w.active = tab
        end)

        btn.MouseEnter:Connect(function()
            play("hover")
            if w.active ~= tab then
                kyri.svc.tw:Create(btn, ti, {BackgroundColor3 = t.hover}):Play()
            end
        end)

        btn.MouseLeave:Connect(function()
            if w.active ~= tab then
                kyri.svc.tw:Create(btn, ti, {BackgroundColor3 = t.element}):Play()
            end
        end)

        tab.btn = btn
        tab.txt = txt
        tab.indicator = indicator
        tab.page = page

        function tab:section(text)
            local frame = make("Frame", {
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundTransparency = 1,
                Parent = page
            })

            make("Frame", {
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.fromScale(0, 0.5),
                BackgroundColor3 = t.border,
                Parent = frame
            })

            make("TextLabel", {
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                Position = UDim2.fromOffset(16, 0),
                BackgroundColor3 = t.bg,
                Text = " " .. text .. " ",
                TextColor3 = t.subtext,
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                Parent = frame
            })

            return frame
        end

        function tab:space(height)
            make("Frame", {
                Size = UDim2.new(1, 0, 0, height or 8),
                BackgroundTransparency = 1,
                Parent = page
            })
        end

        function tab:paragraph(title, text)
            local box = make("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = t.element,
                Parent = page
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = box})
            make("UIPadding", {
                PaddingTop = UDim.new(0, 12),
                PaddingBottom = UDim.new(0, 12),
                PaddingLeft = UDim.new(0, 16),
                PaddingRight = UDim.new(0, 16),
                Parent = box
            })
            make("UIListLayout", {
                Padding = UDim.new(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = box
            })

            local title_lbl = make("TextLabel", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Text = title,
                TextColor3 = t.text,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = box
            })

            local body_lbl = make("TextLabel", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = t.subtext,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = box
            })

            local api = {box = box}
            function api:set(new_title, new_body)
                if new_title then title_lbl.Text = new_title end
                if new_body then body_lbl.Text = new_body end
            end
            return api
        end

        function tab:label(text)
            local lbl = make("TextLabel", {
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = t.subtext,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = page
            })
            make("UIPadding", {
                PaddingLeft = UDim.new(0, 16),
                PaddingRight = UDim.new(0, 16),
                Parent = lbl
            })

            local api = {lbl = lbl}
            function api:set(new_text)
                lbl.Text = new_text
            end
            return api
        end

        function tab:button(text, callback, icon)
            local box = make("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = t.element,
                Parent = page
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = box})

            if icon then
                local icon_id = kyri.icons[icon]
                    or (type(icon) == "string" and (icon:find("^rbxassetid://") or icon:find("^rbxthumb://")) and icon)
                    or "rbxassetid://7743875962"
                local icon_img = make("ImageLabel", {
                    Size = UDim2.fromOffset(18, 18),
                    Position = UDim2.new(0, 14, 0.5, -9),
                    BackgroundTransparency = 1,
                    Image = icon_id,
                    ImageColor3 = t.subtext,
                    Parent = box
                })
                if type(icon) == "string" and icon:find("^https://") then
                    task.spawn(function()
                        pcall(function()
                            local http = request or http_request or syn and syn.request
                            if not http or not getcustomasset then return end
                            local res = http({Url = icon, Method = "GET"})
                            if not res or res.StatusCode ~= 200 then return end
                            if not isfolder("kyrilib_icons") then makefolder("kyrilib_icons") end
                            local fname = "kyrilib_icons/" .. icon:gsub("[^%w]", "_"):sub(1, 64) .. ".png"
                            writefile(fname, res.Body)
                            icon_img.Image = getcustomasset(fname)
                        end)
                    end)
                end
            end

            local text_x = icon and 40 or 16
            local text_w = icon and -56 or -24

            local lbl = make("TextLabel", {
                Size = UDim2.new(1, text_w, 1, 0),
                Position = UDim2.fromOffset(text_x, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = t.text,
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = box
            })

            local click = make("TextButton", {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Text = "",
                Parent = box
            })

            local ripple = make("ImageLabel", {
                Size = UDim2.fromScale(0, 0),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Image = "rbxassetid://4560909609",
                ImageTransparency = 1,
                ImageColor3 = t.accent,
                ZIndex = 2,
                Parent = box
            })
            table.insert(w.accents, {obj = ripple, prop = "ImageColor3"})

            click.MouseButton1Click:Connect(function()
                play("click")
                ripple.Size = UDim2.fromScale(0, 0)
                ripple.ImageTransparency = 0.5
                kyri.svc.tw:Create(ripple, TweenInfo.new(0.4), {
                    Size = UDim2.fromScale(1.5, 1.5),
                    ImageTransparency = 1
                }):Play()
                if callback then callback() end
            end)

            click.MouseEnter:Connect(function()
                play("hover")
                kyri.svc.tw:Create(box, TweenInfo.new(0.15), {BackgroundColor3 = t.hover}):Play()
            end)
            click.MouseLeave:Connect(function()
                kyri.svc.tw:Create(box, TweenInfo.new(0.15), {BackgroundColor3 = t.element}):Play()
            end)

            local api = {box = box}
            function api:set(new_text) lbl.Text = new_text end
            function api:setcallback(fn) callback = fn end
            return api
        end

        function tab:toggle(text, def, callback, flag)
            local state = def or false
            if flag then w.flags[flag] = state end

            local box = make("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = t.element,
                Parent = page
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = box})

            local lbl = make("TextLabel", {
                Size = UDim2.new(1, -80, 1, 0),
                Position = UDim2.fromOffset(16, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = state and t.text or t.subtext,
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = box
            })

            local tog_bg = make("TextButton", {
                Size = UDim2.fromOffset(46, 24),
                Position = UDim2.new(1, -16, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = state and t.accent or t.container,
                Text = "",
                AutoButtonColor = false,
                Parent = box
            })
            make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = tog_bg})

            local knob = make("Frame", {
                Size = UDim2.fromOffset(18, 18),
                Position = state and UDim2.new(1, -3, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                AnchorPoint = Vector2.new(state and 1 or 0, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Parent = tog_bg
            })
            make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = knob})

            local accent_entry = nil
            if state then
                accent_entry = {obj = tog_bg, prop = "BackgroundColor3", is_toggle = true}
                table.insert(w.accents, accent_entry)
            end

            local ti_tog = TweenInfo.new(0.18, Enum.EasingStyle.Quad)

            local function set_state(new_state, run_callback)
                state = new_state
                if flag then w.flags[flag] = state end

                if accent_entry then
                    for i, v in ipairs(w.accents) do
                        if v == accent_entry then
                            table.remove(w.accents, i)
                            break
                        end
                    end
                    accent_entry = nil
                end

                if state then
                    accent_entry = {obj = tog_bg, prop = "BackgroundColor3", is_toggle = true}
                    table.insert(w.accents, accent_entry)
                end

                kyri.svc.tw:Create(tog_bg, ti_tog, {BackgroundColor3 = state and t.accent or t.container}):Play()
                kyri.svc.tw:Create(knob, ti_tog, {
                    Position = state and UDim2.new(1, -3, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                    AnchorPoint = Vector2.new(state and 1 or 0, 0.5)
                }):Play()
                kyri.svc.tw:Create(lbl, ti_tog, {TextColor3 = state and t.text or t.subtext}):Play()

                if run_callback and callback then callback(state) end
            end

            if flag then w.flags[flag .. "_set"] = set_state end

            tog_bg.MouseButton1Click:Connect(function()
                play(state and "toggle_off" or "toggle_on")
                set_state(not state, true)
            end)

            local api = {box = box}
            function api:set(new_state) set_state(new_state, false) end
            function api:get() return state end
            function api:setcallback(fn) callback = fn end
            return api
        end

        function tab:slider(text, min, max, def, callback, flag, step)
            local val = def or min
            if flag then w.flags[flag] = val end

            local box = make("Frame", {
                Size = UDim2.new(1, 0, 0, w.is_mobile and 82 or 58),
                BackgroundColor3 = t.element,
                Parent = page
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = box})

            make("TextLabel", {
                Size = UDim2.new(1, -90, 0, 20),
                Position = UDim2.fromOffset(16, 10),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = t.text,
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = box
            })

            -- value display: click to type a number
            local val_btn = make("TextButton", {
                Size = UDim2.fromOffset(72, 20),
                Position = UDim2.new(1, -16, 0, 10),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Text = tostring(val),
                TextColor3 = t.accent,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                AutoButtonColor = false,
                Parent = box
            })
            table.insert(w.accents, {obj = val_btn, prop = "TextColor3"})

            local val_inp = make("TextBox", {
                Size = UDim2.fromOffset(72, 20),
                Position = UDim2.new(1, -16, 0, 10),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundColor3 = t.container,
                Text = tostring(val),
                TextColor3 = t.text,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                Visible = false,
                Parent = box
            })
            make("UICorner", {CornerRadius = UDim.new(0, 4), Parent = val_inp})
            make("UIPadding", {PaddingRight = UDim.new(0, 4), Parent = val_inp})

            -- track: 8px tall for easier targeting
            local track = make("Frame", {
                Size = UDim2.new(1, -32, 0, 8),
                Position = UDim2.fromOffset(16, 36),
                BackgroundColor3 = t.container,
                Parent = box
            })
            make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = track})

            local fill = make("Frame", {
                Size = UDim2.new((val - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = t.accent,
                Parent = track
            })
            table.insert(w.accents, {obj = fill, prop = "BackgroundColor3"})
            make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = fill})

            -- handle: 18x18 so it's easy to grab
            local handle = make("Frame", {
                Size = UDim2.fromOffset(18, 18),
                Position = UDim2.new((val - min) / (max - min), 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ZIndex = 2,
                Parent = track
            })
            make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = handle})

            -- shared apply: used by drag, type-in, api:set, and config load
            local function apply(new_val, fire_cb)
                if step then
                    new_val = math.floor(new_val / step + 0.5) * step
                    new_val = math.floor(new_val * 1000 + 0.5) / 1000
                else
                    new_val = math.floor(new_val)
                end
                val = math.clamp(new_val, min, max)
                local pct = (val - min) / (max - min)
                fill.Size = UDim2.new(pct, 0, 1, 0)
                handle.Position = UDim2.new(pct, 0, 0.5, 0)
                val_btn.Text = tostring(val)
                if flag then w.flags[flag] = val end
                if fire_cb and callback then callback(val) end
            end

            -- large transparent hit zone: 36px tall covering the track + padding
            -- makes the slider trivial to click and drag on both PC and mobile
            local hit = make("Frame", {
                Size = UDim2.new(1, -32, 0, 36),
                Position = UDim2.fromOffset(16, 20),
                BackgroundTransparency = 1,
                ZIndex = 3,
                Parent = box
            })

            local dragging = false

            local function drag_to(x)
                local pct = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                apply(min + (max - min) * pct, true)
            end

            hit.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1
                   or inp.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    play("toggle_on")
                    drag_to(inp.Position.X)
                end
            end)

            table.insert(conns, kyri.svc.inp.InputChanged:Connect(function(inp)
                if not dragging then return end
                if inp.UserInputType == Enum.UserInputType.MouseMovement
                   or inp.UserInputType == Enum.UserInputType.Touch then
                    drag_to(inp.Position.X)
                end
            end))

            table.insert(conns, kyri.svc.inp.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1
                   or inp.UserInputType == Enum.UserInputType.Touch then
                    if dragging then play("toggle_off") end
                    dragging = false
                end
            end))

            -- click value label → type a number → apply
            val_btn.MouseButton1Click:Connect(function()
                val_btn.Visible = false
                val_inp.Text = tostring(val)
                val_inp.Visible = true
                val_inp:CaptureFocus()
            end)

            val_inp.FocusLost:Connect(function()
                local num = tonumber(val_inp.Text)
                if num then apply(num, true) end
                val_inp.Visible = false
                val_btn.Visible = true
            end)

            -- mobile: keep +/- buttons below the track for fine control
            if w.is_mobile then
                local btn_row = make("Frame", {
                    Size = UDim2.new(1, -32, 0, 28),
                    Position = UDim2.fromOffset(16, 50),
                    BackgroundTransparency = 1,
                    Parent = box
                })
                make("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    Padding = UDim.new(0, 8),
                    Parent = btn_row
                })
                local minus_btn = make("TextButton", {
                    Size = UDim2.new(0.45, 0, 1, 0),
                    BackgroundColor3 = t.container,
                    Text = "–",
                    TextColor3 = t.text,
                    Font = Enum.Font.GothamBold,
                    TextSize = 16,
                    AutoButtonColor = false,
                    Parent = btn_row
                })
                make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = minus_btn})
                local plus_btn = make("TextButton", {
                    Size = UDim2.new(0.45, 0, 1, 0),
                    BackgroundColor3 = t.container,
                    Text = "+",
                    TextColor3 = t.text,
                    Font = Enum.Font.GothamBold,
                    TextSize = 16,
                    AutoButtonColor = false,
                    Parent = btn_row
                })
                make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = plus_btn})

                minus_btn.MouseButton1Click:Connect(function()
                    play("click")
                    apply(val - (step or 1), true)
                end)
                plus_btn.MouseButton1Click:Connect(function()
                    play("click")
                    apply(val + (step or 1), true)
                end)
                minus_btn.MouseEnter:Connect(function()
                    kyri.svc.tw:Create(minus_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.hover}):Play()
                end)
                minus_btn.MouseLeave:Connect(function()
                    kyri.svc.tw:Create(minus_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.container}):Play()
                end)
                plus_btn.MouseEnter:Connect(function()
                    kyri.svc.tw:Create(plus_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.hover}):Play()
                end)
                plus_btn.MouseLeave:Connect(function()
                    kyri.svc.tw:Create(plus_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.container}):Play()
                end)
            end

            local api = {box = box}
            function api:set(new_val) apply(new_val, false) end
            function api:get() return val end
            function api:setcallback(fn) callback = fn end
            if flag then
                w.flags[flag .. "_set"] = function(v, fire) apply(v, fire) end
            end
            return api
        end

        function tab:input(text, placeholder, callback, flag)
            local box = make("Frame", {
                Size = UDim2.new(1, 0, 0, 68),
                BackgroundColor3 = t.element,
                Parent = page
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = box})

            make("TextLabel", {
                Size = UDim2.new(1, -32, 0, 20),
                Position = UDim2.fromOffset(16, 10),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = t.text,
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = box
            })

            local inp = make("TextBox", {
                Size = UDim2.new(1, -32, 0, 30),
                Position = UDim2.fromOffset(16, 34),
                BackgroundColor3 = t.container,
                Text = "",
                PlaceholderText = placeholder or "enter text",
                PlaceholderColor3 = t.subtext,
                TextColor3 = t.text,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false,
                Parent = box
            })
            make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = inp})
            make("UIPadding", {
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10),
                Parent = inp
            })

            if flag then w.flags[flag] = inp.Text end

            inp.FocusLost:Connect(function(enter)
                if flag then w.flags[flag] = inp.Text end
                if callback and enter then
                    play("click")
                    callback(inp.Text)
                end
            end)

            inp:GetPropertyChangedSignal("Text"):Connect(function()
                if flag then w.flags[flag] = inp.Text end
            end)

            local api = {box = box, input = inp}
            function api:set(new_text)
                inp.Text = new_text
                if flag then w.flags[flag] = new_text end
            end
            function api:get() return inp.Text end
            function api:setcallback(fn) callback = fn end
            return api
        end

        function tab:dropdown(text, options, def, callback, flag)
            local selected = def or (options[1] or "none")
            local open = false

            if flag then w.flags[flag] = selected end

            local container = make("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = t.element,
                Parent = page
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = container})

            make("TextLabel", {
                Size = UDim2.new(1, -110, 0, 42),
                Position = UDim2.fromOffset(16, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = t.text,
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3,
                Parent = container
            })

            local dropdown_btn = make("TextButton", {
                Size = UDim2.fromOffset(100, 28),
                Position = UDim2.new(1, -16, 0, 7),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundColor3 = t.container,
                Text = "",
                AutoButtonColor = false,
                ZIndex = 3,
                Parent = container
            })
            make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = dropdown_btn})

            local selected_lbl = make("TextLabel", {
                Size = UDim2.new(1, -30, 1, 0),
                Position = UDim2.fromOffset(10, 0),
                BackgroundTransparency = 1,
                Text = selected,
                TextColor3 = t.text,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = dropdown_btn
            })

            local arrow = make("TextLabel", {
                Size = UDim2.fromOffset(20, 28),
                Position = UDim2.new(1, -5, 0, 0),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Text = "▼",
                TextColor3 = t.subtext,
                Font = Enum.Font.Gotham,
                TextSize = 10,
                Parent = dropdown_btn
            })

            local list_frame = make("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.fromOffset(0, 46),
                BackgroundColor3 = t.bg,
                ClipsDescendants = true,
                Visible = false,
                ZIndex = 2,
                Parent = container
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = list_frame})

            local search_box = make("TextBox", {
                Size = UDim2.new(1, -16, 0, 26),
                Position = UDim2.fromOffset(8, 4),
                BackgroundColor3 = t.element,
                Text = "",
                PlaceholderText = "search...",
                PlaceholderColor3 = t.subtext,
                TextColor3 = t.text,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false,
                ZIndex = 3,
                Parent = list_frame
            })
            make("UICorner", {CornerRadius = UDim.new(0, 5), Parent = search_box})
            make("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = search_box})

            local list_container = make("ScrollingFrame", {
                Size = UDim2.new(1, 0, 1, -34),
                Position = UDim2.fromOffset(0, 34),
                BackgroundTransparency = 1,
                ScrollBarThickness = 3,
                ScrollBarImageColor3 = t.accent,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollingDirection = Enum.ScrollingDirection.Y,
                BorderSizePixel = 0,
                Parent = list_frame
            })
            table.insert(w.accents, {obj = list_container, prop = "ScrollBarImageColor3"})

            local list_layout = make("UIListLayout", {
                Padding = UDim.new(0, 2),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = list_container
            })

            make("UIPadding", {
                PaddingTop = UDim.new(0, 4),
                PaddingBottom = UDim.new(0, 4),
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                Parent = list_container
            })

            list_layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                list_container.CanvasSize = UDim2.new(0, 0, 0, list_layout.AbsoluteContentSize.Y + 8)
            end)

            local opt_refs = {}
            local selected_accent = nil

            local function close_dropdown()
                open = false
                search_box.Text = ""
                for _, ref in ipairs(opt_refs) do ref.btn.Visible = true end
                kyri.svc.tw:Create(container, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 42)}):Play()
                kyri.svc.tw:Create(list_frame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                kyri.svc.tw:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                task.wait(0.2)
                if list_frame and list_frame.Parent then
                    list_frame.Visible = false
                end
            end

            for i, option in ipairs(options) do
                local opt_btn = make("TextButton", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = t.element,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = list_container
                })
                make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = opt_btn})

                local opt_lbl = make("TextLabel", {
                    Size = UDim2.new(1, -16, 1, 0),
                    Position = UDim2.fromOffset(8, 0),
                    BackgroundTransparency = 1,
                    Text = option,
                    TextColor3 = option == selected and t.accent or t.text,
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = opt_btn
                })

                table.insert(opt_refs, {btn = opt_btn, lbl = opt_lbl, text = option})

                if option == selected then
                    selected_accent = {obj = opt_lbl, prop = "TextColor3"}
                    table.insert(w.accents, selected_accent)
                end

                opt_btn.MouseEnter:Connect(function()
                    kyri.svc.tw:Create(opt_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.hover}):Play()
                end)
                opt_btn.MouseLeave:Connect(function()
                    kyri.svc.tw:Create(opt_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.element}):Play()
                end)

                opt_btn.MouseButton1Click:Connect(function()
                    play("click")
                    selected = option
                    selected_lbl.Text = option
                    if flag then w.flags[flag] = selected end

                    if selected_accent then
                        for i2, v in ipairs(w.accents) do
                            if v == selected_accent then
                                table.remove(w.accents, i2)
                                break
                            end
                        end
                        selected_accent.obj.TextColor3 = t.text
                        selected_accent = nil
                    end

                    opt_lbl.TextColor3 = t.accent
                    selected_accent = {obj = opt_lbl, prop = "TextColor3"}
                    table.insert(w.accents, selected_accent)

                    task.spawn(close_dropdown)
                    if callback then callback(option) end
                end)
            end

            search_box:GetPropertyChangedSignal("Text"):Connect(function()
                local q = search_box.Text:lower()
                for _, ref in ipairs(opt_refs) do
                    ref.btn.Visible = q == "" or ref.text:lower():find(q, 1, true) ~= nil
                end
            end)

            dropdown_btn.MouseButton1Click:Connect(function()
                play("click")
                open = not open

                if open then
                    local content_height = list_layout.AbsoluteContentSize.Y + 8
                    local max_list = math.min(content_height, 166)
                    list_frame.Visible = true
                    kyri.svc.tw:Create(container, TweenInfo.new(0.2), {
                        Size = UDim2.new(1, 0, 0, 42 + 34 + max_list + 4)
                    }):Play()
                    kyri.svc.tw:Create(list_frame, TweenInfo.new(0.2), {
                        Size = UDim2.new(1, 0, 0, 34 + max_list)
                    }):Play()
                    kyri.svc.tw:Create(arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
                else
                    task.spawn(close_dropdown)
                end
            end)

            table.insert(conns, kyri.svc.inp.InputBegan:Connect(function(inp, gpe)
                if not open then return end
                if inp.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
                local pos = inp.Position
                local ap = container.AbsolutePosition
                local as = container.AbsoluteSize
                if pos.X < ap.X or pos.X > ap.X + as.X or pos.Y < ap.Y or pos.Y > ap.Y + as.Y then
                    task.spawn(close_dropdown)
                end
            end))

            dropdown_btn.MouseEnter:Connect(function()
                play("hover")
                kyri.svc.tw:Create(dropdown_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.hover}):Play()
            end)
            dropdown_btn.MouseLeave:Connect(function()
                kyri.svc.tw:Create(dropdown_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.container}):Play()
            end)

            local api = {container = container}
            function api:set(option)
                selected = option
                selected_lbl.Text = option
                if flag then w.flags[flag] = selected end
                if selected_accent then
                    for i2, v in ipairs(w.accents) do
                        if v == selected_accent then
                            table.remove(w.accents, i2)
                            break
                        end
                    end
                    selected_accent.obj.TextColor3 = t.text
                    selected_accent = nil
                end
                for _, child in ipairs(list_container:GetChildren()) do
                    if child:IsA("TextButton") then
                        local lbl = child:FindFirstChildOfClass("TextLabel")
                        if lbl and lbl.Text == option then
                            lbl.TextColor3 = t.accent
                            selected_accent = {obj = lbl, prop = "TextColor3"}
                            table.insert(w.accents, selected_accent)
                        end
                    end
                end
            end
            function api:get() return selected end
            function api:setcallback(fn) callback = fn end
            return api
        end

        function tab:multiselect(text, options, def, callback, flag)
            local selected = {}
            if def then
                for _, v in ipairs(def) do selected[v] = true end
            end
            local open = false

            local function get_list()
                local out = {}
                for k, v in pairs(selected) do
                    if v then table.insert(out, k) end
                end
                return out
            end

            local function display_text()
                local list = get_list()
                if #list == 0 then return "none" end
                if #list == 1 then return list[1] end
                return #list .. " selected"
            end

            if flag then w.flags[flag] = get_list() end

            local container = make("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = t.element,
                Parent = page
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = container})

            make("TextLabel", {
                Size = UDim2.new(1, -110, 0, 42),
                Position = UDim2.fromOffset(16, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = t.text,
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3,
                Parent = container
            })

            local dropdown_btn = make("TextButton", {
                Size = UDim2.fromOffset(100, 28),
                Position = UDim2.new(1, -16, 0, 7),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundColor3 = t.container,
                Text = "",
                AutoButtonColor = false,
                ZIndex = 3,
                Parent = container
            })
            make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = dropdown_btn})

            local selected_lbl = make("TextLabel", {
                Size = UDim2.new(1, -30, 1, 0),
                Position = UDim2.fromOffset(10, 0),
                BackgroundTransparency = 1,
                Text = display_text(),
                TextColor3 = t.text,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = dropdown_btn
            })

            local arrow = make("TextLabel", {
                Size = UDim2.fromOffset(20, 28),
                Position = UDim2.new(1, -5, 0, 0),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Text = "▼",
                TextColor3 = t.subtext,
                Font = Enum.Font.Gotham,
                TextSize = 10,
                Parent = dropdown_btn
            })

            local list_frame = make("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.fromOffset(0, 46),
                BackgroundColor3 = t.bg,
                ClipsDescendants = true,
                Visible = false,
                ZIndex = 2,
                Parent = container
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = list_frame})

            local list_container = make("ScrollingFrame", {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                ScrollBarThickness = 3,
                ScrollBarImageColor3 = t.accent,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollingDirection = Enum.ScrollingDirection.Y,
                BorderSizePixel = 0,
                Parent = list_frame
            })
            table.insert(w.accents, {obj = list_container, prop = "ScrollBarImageColor3"})

            local list_layout = make("UIListLayout", {
                Padding = UDim.new(0, 2),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = list_container
            })

            make("UIPadding", {
                PaddingTop = UDim.new(0, 4),
                PaddingBottom = UDim.new(0, 4),
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                Parent = list_container
            })

            list_layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                list_container.CanvasSize = UDim2.new(0, 0, 0, list_layout.AbsoluteContentSize.Y + 8)
            end)

            local function close_ms()
                open = false
                kyri.svc.tw:Create(container, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 42)}):Play()
                kyri.svc.tw:Create(list_frame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                kyri.svc.tw:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                task.wait(0.2)
                if list_frame and list_frame.Parent then
                    list_frame.Visible = false
                end
            end

            for i, option in ipairs(options) do
                local is_sel = selected[option] == true

                local opt_btn = make("TextButton", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = is_sel and t.active or t.element,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = list_container
                })
                make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = opt_btn})

                local opt_lbl = make("TextLabel", {
                    Size = UDim2.new(1, -46, 1, 0),
                    Position = UDim2.fromOffset(8, 0),
                    BackgroundTransparency = 1,
                    Text = option,
                    TextColor3 = is_sel and t.accent or t.text,
                    Font = Enum.Font.Gotham,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = opt_btn
                })

                local check = make("TextLabel", {
                    Size = UDim2.fromOffset(20, 20),
                    Position = UDim2.new(1, -8, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundTransparency = 1,
                    Text = is_sel and "✓" or "",
                    TextColor3 = t.accent,
                    Font = Enum.Font.GothamBold,
                    TextSize = 14,
                    Parent = opt_btn
                })

                if is_sel then
                    table.insert(w.accents, {obj = opt_lbl, prop = "TextColor3"})
                    table.insert(w.accents, {obj = check, prop = "TextColor3"})
                end

                opt_btn.MouseEnter:Connect(function()
                    if not selected[option] then
                        kyri.svc.tw:Create(opt_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.hover}):Play()
                    end
                end)
                opt_btn.MouseLeave:Connect(function()
                    if not selected[option] then
                        kyri.svc.tw:Create(opt_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.element}):Play()
                    end
                end)

                opt_btn.MouseButton1Click:Connect(function()
                    play("click")
                    selected[option] = not selected[option]
                    local now = selected[option] == true
                    check.Text = now and "✓" or ""
                    opt_lbl.TextColor3 = now and t.accent or t.text
                    opt_btn.BackgroundColor3 = now and t.active or t.element
                    selected_lbl.Text = display_text()
                    if flag then w.flags[flag] = get_list() end
                    if callback then callback(get_list()) end
                end)
            end

            dropdown_btn.MouseButton1Click:Connect(function()
                play("click")
                open = not open

                if open then
                    local content_height = list_layout.AbsoluteContentSize.Y + 8
                    local max_height = math.min(content_height, 200)
                    list_frame.Visible = true
                    kyri.svc.tw:Create(container, TweenInfo.new(0.2), {
                        Size = UDim2.new(1, 0, 0, 42 + max_height + 4)
                    }):Play()
                    kyri.svc.tw:Create(list_frame, TweenInfo.new(0.2), {
                        Size = UDim2.new(1, 0, 0, max_height)
                    }):Play()
                    kyri.svc.tw:Create(arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
                else
                    task.spawn(close_ms)
                end
            end)

            table.insert(conns, kyri.svc.inp.InputBegan:Connect(function(inp, gpe)
                if not open then return end
                if inp.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
                local pos = inp.Position
                local ap = container.AbsolutePosition
                local as = container.AbsoluteSize
                if pos.X < ap.X or pos.X > ap.X + as.X or pos.Y < ap.Y or pos.Y > ap.Y + as.Y then
                    task.spawn(close_ms)
                end
            end))

            dropdown_btn.MouseEnter:Connect(function()
                play("hover")
                kyri.svc.tw:Create(dropdown_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.hover}):Play()
            end)
            dropdown_btn.MouseLeave:Connect(function()
                kyri.svc.tw:Create(dropdown_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.container}):Play()
            end)

            local api = {container = container}
            function api:get() return get_list() end
            function api:setcallback(fn) callback = fn end
            return api
        end

        function tab:colorpicker(text, def, callback, flag)
            local current = def or Color3.fromRGB(255, 255, 255)
            if flag then w.flags[flag] = current end

            local box = make("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = t.element,
                Parent = page
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = box})

            make("TextLabel", {
                Size = UDim2.new(1, -80, 1, 0),
                Position = UDim2.fromOffset(16, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = t.text,
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = box
            })

            local preview_btn = make("TextButton", {
                Size = UDim2.fromOffset(44, 22),
                Position = UDim2.new(1, -16, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = current,
                Text = "",
                AutoButtonColor = false,
                Parent = box
            })
            make("UICorner", {CornerRadius = UDim.new(0, 5), Parent = preview_btn})

            local function on_color(c)
                current = c
                preview_btn.BackgroundColor3 = c
                if flag then w.flags[flag] = c end
                if callback then callback(c) end
            end

            preview_btn.MouseButton1Click:Connect(function()
                play("click")
                make_colorpicker_popup(current, on_color)
            end)

            preview_btn.MouseEnter:Connect(function()
                play("hover")
                kyri.svc.tw:Create(box, TweenInfo.new(0.15), {BackgroundColor3 = t.hover}):Play()
            end)
            preview_btn.MouseLeave:Connect(function()
                kyri.svc.tw:Create(box, TweenInfo.new(0.15), {BackgroundColor3 = t.element}):Play()
            end)

            local api = {box = box}
            function api:set(color) on_color(color) end
            function api:get() return current end
            function api:setcallback(fn) callback = fn end
            return api
        end

        function tab:image(id, height, scale_type)
            height = height or 120
            local box = make("Frame", {
                Size = UDim2.new(1, 0, 0, height),
                BackgroundColor3 = t.element,
                Parent = page
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = box})

            local img = make("ImageLabel", {
                Size = UDim2.new(1, -8, 1, -8),
                Position = UDim2.fromOffset(4, 4),
                BackgroundTransparency = 1,
                Image = id or "",
                ScaleType = scale_type or Enum.ScaleType.Fit,
                Parent = box
            })
            make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = img})

            local api = {box = box, img = img}
            function api:set(new_id) img.Image = new_id end
            return api
        end

        function tab:progressbar(text, max_val)
            max_val = max_val or 100
            local cur = 0

            local box = make("Frame", {
                Size = UDim2.new(1, 0, 0, 52),
                BackgroundColor3 = t.element,
                Parent = page
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = box})

            make("TextLabel", {
                Size = UDim2.new(1, -90, 0, 20),
                Position = UDim2.fromOffset(16, 8),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = t.text,
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = box
            })

            local pct_lbl = make("TextLabel", {
                Size = UDim2.fromOffset(60, 20),
                Position = UDim2.new(1, -16, 0, 8),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Text = "0%",
                TextColor3 = t.accent,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = box
            })
            table.insert(w.accents, {obj = pct_lbl, prop = "TextColor3"})

            local track = make("Frame", {
                Size = UDim2.new(1, -32, 0, 5),
                Position = UDim2.fromOffset(16, 34),
                BackgroundColor3 = t.container,
                Parent = box
            })
            make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = track})

            local fill = make("Frame", {
                Size = UDim2.fromScale(0, 1),
                BackgroundColor3 = t.accent,
                Parent = track
            })
            table.insert(w.accents, {obj = fill, prop = "BackgroundColor3"})
            make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = fill})

            local api = {box = box}
            function api:set(val, animate)
                cur = math.clamp(val, 0, max_val)
                local pct = cur / max_val
                pct_lbl.Text = math.floor(pct * 100) .. "%"
                if animate then
                    kyri.svc.tw:Create(fill, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                        Size = UDim2.fromScale(pct, 1)
                    }):Play()
                else
                    fill.Size = UDim2.fromScale(pct, 1)
                end
            end
            function api:get() return cur end
            return api
        end

        function tab:keybind(text, default, hold_to_interact, callback, flag)
            local current_key = default or "None"
            local listening = false
            local holding = false
            local is_mouse = false

            local mouse_names = {
                [Enum.UserInputType.MouseButton1] = "Mouse1",
                [Enum.UserInputType.MouseButton2] = "Mouse2",
                [Enum.UserInputType.MouseButton3] = "Mouse3"
            }

            if flag then w.flags[flag] = current_key end

            local box = make("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = t.element,
                Parent = page
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = box})

            make("TextLabel", {
                Size = UDim2.new(1, -130, 1, 0),
                Position = UDim2.fromOffset(16, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = t.text,
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = box
            })

            local keybind_btn = make("TextButton", {
                Size = UDim2.fromOffset(100, 28),
                Position = UDim2.new(1, -16, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = t.container,
                Text = current_key,
                TextColor3 = t.text,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                AutoButtonColor = false,
                Parent = box
            })
            make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = keybind_btn})

            local function update_key(new_key, mouse)
                current_key = new_key
                is_mouse = mouse or false
                keybind_btn.Text = new_key
                if flag then w.flags[flag] = new_key end
            end

            keybind_btn.MouseButton1Click:Connect(function()
                if listening then return end
                listening = true
                keybind_btn.Text = "..."
                play("click")

                local conn
                conn = kyri.svc.inp.InputBegan:Connect(function(input, gpe)
                    if gpe then return end

                    local mname = mouse_names[input.UserInputType]
                    if mname then
                        conn:Disconnect()
                        listening = false
                        update_key(mname, true)
                        return
                    end

                    local key = input.KeyCode.Name
                    if key ~= "Unknown" then
                        conn:Disconnect()
                        listening = false
                        update_key(key, false)
                    end
                end)
            end)

            table.insert(conns, kyri.svc.inp.InputBegan:Connect(function(input, gpe)
                if gpe or listening then return end

                local triggered = false
                if is_mouse then
                    triggered = mouse_names[input.UserInputType] == current_key
                else
                    triggered = input.KeyCode.Name == current_key
                end

                if triggered then
                    if hold_to_interact then
                        holding = true
                        if callback then callback(true) end
                    else
                        if callback then callback() end
                    end
                end
            end))

            table.insert(conns, kyri.svc.inp.InputEnded:Connect(function(input, gpe)
                if not hold_to_interact or not holding then return end

                local released = false
                if is_mouse then
                    released = mouse_names[input.UserInputType] == current_key
                else
                    released = input.KeyCode.Name == current_key
                end

                if released then
                    holding = false
                    if callback then callback(false) end
                end
            end))

            keybind_btn.MouseEnter:Connect(function()
                play("hover")
                kyri.svc.tw:Create(keybind_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.hover}):Play()
            end)
            keybind_btn.MouseLeave:Connect(function()
                kyri.svc.tw:Create(keybind_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.container}):Play()
            end)

            local api = {box = box}
            function api:set(new_key, mouse) update_key(new_key, mouse) end
            function api:get() return current_key end
            function api:setcallback(fn) callback = fn end
            return api
        end

        table.insert(w.tabs, tab)

        if not w.active then
            task.wait()
            page.Visible = true
            kyri.svc.tw:Create(btn, ti, {BackgroundColor3 = t.hover}):Play()
            kyri.svc.tw:Create(txt, ti, {TextColor3 = t.text}):Play()
            kyri.svc.tw:Create(indicator, ti, {Size = UDim2.new(0, 3, 0, 38)}):Play()
            if tab.icon then
                kyri.svc.tw:Create(tab.icon, ti, {ImageColor3 = t.text}):Play()
            end
            w.active = tab
        end

        return tab
    end

    function w:create_settings()
        local settings = self:tab("Settings")

        settings:label("config management")

        local config_name_result = settings:input("config name", "MyConfig", function() end)
        local config_name_input = config_name_result.input

        local function create_popup(ptitle, message, on_yes)
            local popup_gui = make("ScreenGui", {
                Name = "KyriPopup",
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
                ResetOnSpawn = false,
                IgnoreGuiInset = true,
                DisplayOrder = 999999999,
                Parent = kyri.svc.plr.LocalPlayer.PlayerGui
            })

            local overlay = make("Frame", {
                Size = UDim2.fromScale(1, 1),
                BackgroundColor3 = Color3.new(0, 0, 0),
                BackgroundTransparency = 0.5,
                Parent = popup_gui
            })

            local popup = make("Frame", {
                Size = UDim2.fromOffset(320, 160),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = t.bg,
                Parent = overlay
            })
            make("UICorner", {CornerRadius = UDim.new(0, 10), Parent = popup})

            make("TextLabel", {
                Size = UDim2.new(1, -32, 0, 30),
                Position = UDim2.fromOffset(16, 16),
                BackgroundTransparency = 1,
                Text = ptitle,
                TextColor3 = t.text,
                Font = Enum.Font.GothamBold,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = popup
            })

            make("TextLabel", {
                Size = UDim2.new(1, -32, 0, 40),
                Position = UDim2.fromOffset(16, 50),
                BackgroundTransparency = 1,
                Text = message,
                TextColor3 = t.subtext,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = popup
            })

            local btn_container = make("Frame", {
                Size = UDim2.new(1, -32, 0, 36),
                Position = UDim2.fromOffset(16, 108),
                BackgroundTransparency = 1,
                Parent = popup
            })
            make("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0, 8),
                Parent = btn_container
            })

            local function create_btn(label, is_yes)
                local btn = make("TextButton", {
                    Size = UDim2.fromOffset(140, 36),
                    BackgroundColor3 = is_yes and t.accent or t.element,
                    Text = label,
                    TextColor3 = t.text,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 13,
                    AutoButtonColor = false,
                    Parent = btn_container
                })
                make("UICorner", {CornerRadius = UDim.new(0, 6), Parent = btn})

                btn.MouseEnter:Connect(function()
                    kyri.svc.tw:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = t.hover}):Play()
                end)
                btn.MouseLeave:Connect(function()
                    kyri.svc.tw:Create(btn, TweenInfo.new(0.15), {
                        BackgroundColor3 = is_yes and t.accent or t.element
                    }):Play()
                end)
                btn.MouseButton1Click:Connect(function()
                    if is_yes and on_yes then on_yes() end
                    popup_gui:Destroy()
                end)
            end

            create_btn("yes", true)
            create_btn("no", false)
        end

        local function refresh_configs()
            for _, child in ipairs(settings.page:GetChildren()) do
                if child.Name == "KyriConfigRow" then
                    child:Destroy()
                end
            end

            local configs = list_configs(w.game_name)
            for _, cfg_name in ipairs(configs) do
                local cfg_btn = make("Frame", {
                    Name = "KyriConfigRow",
                    Size = UDim2.new(1, 0, 0, 42),
                    BackgroundColor3 = t.element,
                    Parent = settings.page
                })
                make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = cfg_btn})

                local load_btn = make("TextButton", {
                    Size = UDim2.new(1, -50, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    Parent = cfg_btn
                })

                make("TextLabel", {
                    Size = UDim2.new(1, -10, 1, 0),
                    Position = UDim2.fromOffset(16, 0),
                    BackgroundTransparency = 1,
                    Text = cfg_name,
                    TextColor3 = t.text,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = load_btn
                })

                local delete_btn = make("ImageButton", {
                    Size = UDim2.fromOffset(20, 20),
                    Position = UDim2.new(1, -15, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://6022668885",
                    ImageColor3 = t.subtext,
                    Parent = cfg_btn
                })

                load_btn.MouseEnter:Connect(function()
                    kyri.svc.tw:Create(cfg_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.hover}):Play()
                end)
                load_btn.MouseLeave:Connect(function()
                    kyri.svc.tw:Create(cfg_btn, TweenInfo.new(0.15), {BackgroundColor3 = t.element}):Play()
                end)
                delete_btn.MouseEnter:Connect(function()
                    kyri.svc.tw:Create(delete_btn, TweenInfo.new(0.15), {ImageColor3 = Color3.fromRGB(255, 100, 100)}):Play()
                end)
                delete_btn.MouseLeave:Connect(function()
                    kyri.svc.tw:Create(delete_btn, TweenInfo.new(0.15), {ImageColor3 = t.subtext}):Play()
                end)

                load_btn.MouseButton1Click:Connect(function()
                    local data = load_config(w.game_name, cfg_name)
                    if data then
                        for flag, value in pairs(data) do
                            w.flags[flag] = value
                            local set_func = w.flags[flag .. "_set"]
                            if set_func then set_func(value, true) end
                        end
                    end
                end)

                delete_btn.MouseButton1Click:Connect(function()
                    create_popup(
                        "delete config",
                        "are you sure you want to delete '" .. cfg_name .. "'?",
                        function()
                            delete_config(w.game_name, cfg_name)
                            refresh_configs()
                        end
                    )
                end)
            end
        end

        settings:button("save config", function()
            if config_name_input and config_name_input.Text ~= "" then
                local cfg_name = config_name_input.Text
                local data = {}
                for flag, value in pairs(w.flags) do
                    if not flag:match("_set$") then
                        data[flag] = value
                    end
                end
                save_config(w.game_name, cfg_name, data)
                refresh_configs()
            end
        end)

        settings:label("saved configs")
        refresh_configs()

        settings:space(8)
        settings:section("theme")

        local preset_names = {}
        for name in pairs(kyri.presets) do table.insert(preset_names, name) end
        table.sort(preset_names)
        settings:dropdown("preset", preset_names, "kyri", function(name)
            local p = kyri.presets[name]
            if p then w:apply_theme(p) end
        end)

        settings:space(4)
        settings:section("custom colors")

        local theme_props = {
            {"bg",        "background"},
            {"container", "header"},
            {"element",   "elements"},
            {"accent",    "accent"},
            {"text",      "text"},
            {"subtext",   "subtext"},
            {"border",    "border"},
        }

        for _, pair in ipairs(theme_props) do
            local key, label = pair[1], pair[2]

            local row = make("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = t.element,
                Parent = settings.page
            })
            make("UICorner", {CornerRadius = UDim.new(0, 8), Parent = row})

            make("TextLabel", {
                Size = UDim2.new(1, -80, 1, 0),
                Position = UDim2.fromOffset(16, 0),
                BackgroundTransparency = 1,
                Text = label,
                TextColor3 = t.text,
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = row
            })

            local swatch = make("TextButton", {
                Size = UDim2.fromOffset(44, 22),
                Position = UDim2.new(1, -16, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = t[key],
                Text = "",
                AutoButtonColor = false,
                Parent = row
            })
            make("UICorner", {CornerRadius = UDim.new(0, 5), Parent = swatch})

            row.MouseEnter:Connect(function()
                kyri.svc.tw:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = t.hover}):Play()
            end)
            row.MouseLeave:Connect(function()
                kyri.svc.tw:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = t.element}):Play()
            end)

            swatch.MouseButton1Click:Connect(function()
                play("click")
                make_colorpicker_popup(t[key], function(c)
                    swatch.BackgroundColor3 = c
                    w:apply_theme({[key] = c})
                end)
            end)
        end

        return settings
    end

    task.spawn(function()
        task.wait(0.1)
        w:create_settings()
        if options.AutoLoad then
            local data = load_config(w.game_name, options.AutoLoad)
            if data then
                for flag, value in pairs(data) do
                    w.flags[flag] = value
                    local set_func = w.flags[flag .. "_set"]
                    if set_func then set_func(value, true) end
                end
            end
        end
    end)

    function w:notify(title, text, duration)
        duration = duration or 3

        local notif_gui = w.localPlayer.PlayerGui:FindFirstChild("KyriNotifications")
        if not notif_gui then
            notif_gui = make("ScreenGui", {
                Name = "KyriNotifications",
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
                ResetOnSpawn = false,
                IgnoreGuiInset = true,
                DisplayOrder = 999999998,
                Parent = w.localPlayer.PlayerGui
            })

            local container = make("Frame", {
                Name = "Container",
                Size = UDim2.new(0, 320, 1, 0),
                Position = UDim2.new(1, -20, 0, 20),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Parent = notif_gui
            })

            make("UIListLayout", {
                Padding = UDim.new(0, 10),
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Top,
                Parent = container
            })
        end

        local container = notif_gui.Container

        -- wrapper holds all pieces as siblings so nothing clips anything
        local wrapper = make("Frame", {
            Size = UDim2.fromOffset(320, 77),
            BackgroundTransparency = 1,
            Parent = container
        })

        -- accent bar: sits to the left of the notif (bar rel X=-16, Y=4, W=13, H=63)
        local bar = make("Frame", {
            Size = UDim2.fromOffset(13, 63),
            Position = UDim2.fromOffset(-16, 4),
            BackgroundColor3 = t.accent,
            Parent = wrapper
        })
        make("UICorner", {CornerRadius = UDim.new(1, 0), Parent = bar})

        local notif = make("Frame", {
            Size = UDim2.fromOffset(320, 70),
            BackgroundColor3 = t.bg,
            BackgroundTransparency = 0.2,
            Parent = wrapper
        })
        make("UICorner", {CornerRadius = UDim.new(0, 10), Parent = notif})

        local title_lbl = make("TextLabel", {
            Size = UDim2.new(1, -24, 0, 20),
            Position = UDim2.fromOffset(14, 10),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = t.text,
            Font = Enum.Font.GothamBold,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = notif
        })

        local text_lbl = make("TextLabel", {
            Size = UDim2.new(1, -24, 0, 30),
            Position = UDim2.fromOffset(14, 32),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = t.subtext,
            Font = Enum.Font.Gotham,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
            Parent = notif
        })

        -- progress bar: sits below the notif (prog rel Y=74, H=3)
        local prog_bg = make("Frame", {
            Size = UDim2.fromOffset(320, 3),
            Position = UDim2.fromOffset(0, 74),
            BackgroundColor3 = t.container,
            Parent = wrapper
        })
        local prog_fill = make("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = t.accent,
            Parent = prog_bg
        })

        local dismissed = false
        local function dismiss()
            if dismissed then return end
            dismissed = true
            kyri.svc.tw:Create(notif, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            kyri.svc.tw:Create(bar, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            kyri.svc.tw:Create(title_lbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            kyri.svc.tw:Create(text_lbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            kyri.svc.tw:Create(prog_fill, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            kyri.svc.tw:Create(prog_bg, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            task.wait(0.3)
            if wrapper and wrapper.Parent then wrapper:Destroy() end
        end

        local click_btn = make("TextButton", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 5,
            Parent = notif
        })
        click_btn.MouseButton1Click:Connect(dismiss)

        wrapper.Position = UDim2.new(0, 340, 0, 0)
        kyri.svc.tw:Create(wrapper, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()
        kyri.svc.tw:Create(prog_fill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
            Size = UDim2.fromScale(0, 1)
        }):Play()

        task.delay(duration, dismiss)
    end

    function w:accent(color)
        t.accent = color
        for _, d in ipairs(w.accents) do
            if d.obj and d.obj.Parent then
                d.obj[d.prop] = color
            end
        end
    end

    function w:apply_theme(overrides)
        for key, new_color in pairs(overrides) do
            local old_color = t[key]
            t[key] = new_color
            if key == "accent" then
                for _, d in ipairs(w.accents) do
                    if d.obj and d.obj.Parent then
                        d.obj[d.prop] = new_color
                    end
                end
            elseif old_color then
                for _, obj in ipairs(main:GetDescendants()) do
                    pcall(function()
                        if obj:IsA("GuiObject") and obj.BackgroundColor3 == old_color then
                            obj.BackgroundColor3 = new_color
                        end
                        if (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox"))
                           and obj.TextColor3 == old_color then
                            obj.TextColor3 = new_color
                        end
                        if obj:IsA("UIStroke") and obj.Color == old_color then
                            obj.Color = new_color
                        end
                        if (obj:IsA("ImageLabel") or obj:IsA("ImageButton"))
                           and obj.ImageColor3 == old_color then
                            obj.ImageColor3 = new_color
                        end
                    end)
                end
            end
        end
    end

    function w:destroy()
        for _, c in ipairs(conns) do
            pcall(function() c:Disconnect() end)
        end
        if w.gui and w.gui.Parent then w.gui:Destroy() end
        local ng = w.localPlayer.PlayerGui:FindFirstChild("KyriNotifications")
        if ng then ng:Destroy() end
        if w.is_mobile then
            pcall(function() kyri.svc.cas:UnbindAction("KyriToggle") end)
        end
    end

    if getgenv then getgenv().__kyri_inst = w end
    return w
end

return kyri
