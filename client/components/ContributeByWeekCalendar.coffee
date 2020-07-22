import styles from './ContributeByWeekCalendar.css'

React = require('react')

export default ContributeByWeekCalendar = (props) ->
    submits = props.calendar.byDay.submits
    startday = new Date()
    startday.setMonth(startday.getMonth() - 12)
    start = startday.getDate() - startday.getDay() + 1
    startday = new Date(startday.setDate(start))
    lastday = new Date()
    last = lastday.getDate() - lastday.getDay() + 7
    lastday = new Date(lastday.setDate(last))
    d = startday
    row = []
    column = []
    dayOfWeek = 0
    weeks = 0
    xMonth = {}
    while d <= lastday
        currDay = "#{d.getFullYear()}-#{d.getMonth() + 1}-#{d.getDate()}"
        if d.getDate() == 15 then xMonth[d.getMonth()] = weeks
        color = "#ebedf0"
        if currDay of submits
            c = submits[currDay]
            if c < 3
                color = "#9be9a8"
            else if c < 7
                color = "#40c463"
            else if c < 10
                color = "#30a14e"
            else
                color = "#216e39"
        column.push <rect key={currDay} onClick={do (currDay) -> -> if currDay of submits then props.clickOnDay(currDay)} className={"day"} width={"11"} height={"11"} x={weeks * 16} y={dayOfWeek * 15} fill={color}>{if currDay of submits then <title>{"#{submits[currDay]} посылок на #{currDay}"}</title>}</rect>
        dayOfWeek++
        if dayOfWeek == 7
            dayOfWeek = 0
            weeks++
            row.push <g key={weeks} transform={"translate(#{16}, #{0})"}>{column}</g>
            column = []
        d.setDate d.getDate()+1
    months = []
    yearMonths = ["Янв", "Фев", "Мар", "Апр", "Май", "Июн", "Июл", "Авг", "Снт", "Окт", "Нбр", "Дек"]
    for m of xMonth
        months.push <text key={m} x={xMonth[m] * 16} y={"-8"} className={"month"}>{yearMonths[m]}</text>
    <div>
      <div style={borderRadius: "6px", border: "1px solid #e1e4e8", width: weeks * 16 + 20 + 20, float: "left"}>
        <div style={display: "flex", paddingTop: "4px", marginRight: "8px", \
                    marginLeft: "8px", height: "135", overflow: "hidden", \
                    alignItems: "start", flexDirection: "column"}>
          <svg width={weeks * 16 + 20} height={"128"}>
            <g transform={"translate(10, 20)"}>
              {row}
              {months}
              <text textAnchor={"start"} className={"wday"} dx={"-10"} dy={"8"} style={display: "none"}>пн</text>
              <text textAnchor={"start"} className={"wday"} dx={"-10"} dy={"25"}>вт</text>
              <text textAnchor={"start"} className={"wday"} dx={"-10"} dy={"32"} style={display: "none"}>ср</text>
              <text textAnchor={"start"} className={"wday"} dx={"-10"} dy={"56"}>чт</text>
              <text textAnchor={"start"} className={"wday"} dx={"-10"} dy={"57"} style={display: "none"}>пт</text>
              <text textAnchor={"start"} className={"wday"} dx={"-10"} dy={"85"}>сб</text>
              <text textAnchor={"start"} className={"wday"} dx={"-10"} dy={"81"} style={display: "none"}>вс</text>
            </g>
          </svg>
        </div>
      </div>
      <div className="clearfix" ></div>
    </div>
