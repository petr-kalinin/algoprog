import styles from './ContributeByWeekCalendar.css'

React = require('react')

export default class ContributeByWeekCalendar extends React.PureComponent
    componentDidMount: () ->
        if @table_div
            @table_div?.scrollTo?(10000, 0)

    render: () ->
        submits = @props.calendar.byDay
        # startday is monday of "currentday minus 1 year"
        # lastday is sunday of current week
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
            if submits and (currDay of submits)
                c = submits[currDay]
                if c < 3
                    color = "#9be9a8"
                else if c < 7
                    color = "#40c463"
                else if c < 10
                    color = "#30a14e"
                else
                    color = "#216e39"
            onClickFun = do (currDay) => => if submits and (currDay of submits) then @props.clickOnDay(currDay)
            title = currDay
            if submits and (currDay of submits)
                title += ": #{submits[currDay]}"
            column.push <rect key={currDay} onClick={onClickFun} width="11" height="11" x={weeks * 16} y={dayOfWeek * 15} fill={color}>
                    <title>{title}</title>
                </rect>
            dayOfWeek++
            if dayOfWeek == 7
                dayOfWeek = 0
                weeks++
                row.push <g key={weeks} transform="translate(16, 0)">{column}</g>
                column = []
            d.setDate d.getDate()+1
        months = []
        yearMonths = ["Янв", "Фев", "Мар", "Апр", "Май", "Июн", "Июл", "Авг", "Сен", "Окт", "Ноя", "Дек"]
        for m of xMonth
            months.push <text key={m} x={xMonth[m] * 16} y="-8">{yearMonths[m]}</text>
        # markup of calendar is captured from github calendar html element under text "contributions in the last year"
        <div>
            <div className={styles.outerDiv} ref={(d) => if d then @table_div = d }>
                <div className={styles.innerDiv} style={width: weeks * 16 + 20 + 20}>
                    <svg width={weeks * 16 + 20} height="128">
                        <g transform="translate(10, 20)">
                            {row}
                            {months}
                            <text dx="-10" dy="8" style={display: "none"}>пн</text>
                            <text dx="-10" dy="25">вт</text>
                            <text dx="-10" dy="32" style={display: "none"}>ср</text>
                            <text dx="-10" dy="56">чт</text>
                            <text dx="-10" dy="57" style={display: "none"}>пт</text>
                            <text dx="-10" dy="85">сб</text>
                            <text dx="-10" dy="81" style={display: "none"}>вс</text>
                        </g>
                    </svg>
                </div>
            </div>
            <div className={styles.clearfix} ></div>
        </div>
