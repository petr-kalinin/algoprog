import level from "../lib/level"
import level_roi2004 from "./level_roi2004"
import level_roi2005 from "./level_roi2005"
import level_roi2006 from "./level_roi2006"
import level_roi2007 from "./level_roi2007"
import level_roi2008 from "./level_roi2008"
import level_roi2009 from "./level_roi2009"
import level_roi2010 from "./level_roi2010"
import level_roi2011 from "./level_roi2011"
import level_roi2012 from "./level_roi2012"
import level_roi2013 from "./level_roi2013"
import level_roi2014 from "./level_roi2014"
import level_roi2015 from "./level_roi2015"
import level_roi2016 from "./level_roi2016"
import level_roi2017 from "./level_roi2017"
import level_roi2018 from "./level_roi2018"
import level_roi2019 from "./level_roi2019"
import level_roi2021 from "./level_roi2021"
import level_roi2022 from "./level_roi2022"
import level_roi2023 from "./level_roi2023"


export default level_roi = () ->
    return level("roi", "Всероссийские олимпиады", [
        level_roi2004(),
        level_roi2005(),
        level_roi2006(),
        level_roi2007(),
        level_roi2008(),
        level_roi2009(),
        level_roi2010(),
        level_roi2011(),
        level_roi2012(),
        level_roi2013(),
        level_roi2014(),
        level_roi2015(),
        level_roi2016(),
        level_roi2017(),
        level_roi2018(),
        level_roi2019(),
        level_roi2021(),
        level_roi2022(),
        level_roi2023(),
    ])