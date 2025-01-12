<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Date Picker</title>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/test.css">
</head>
<body>
   <div id="date-picker-container" class="calendar-container" >
    <div class="calendar-header">
        <button id="prev-month" onclick="changeMonth(-1)">&#8249;</button>
        <span id="current-month"></span>
        <button id="next-month" onclick="changeMonth(1)">&#8250;</button>
    </div>
    <div id="calendar-days" class="calendar-days"></div>
</div>


    <!-- Include this script directly in your JSP -->
    <script>
        // Selectors
        const calendarDays = document.getElementById('calendar-days');
        const currentMonth = document.getElementById('current-month');
        const prevMonthButton = document.getElementById('prev-month');
        const nextMonthButton = document.getElementById('next-month');

        // Initialize variables
        let selectedDate = new Date();
        let currentYear = selectedDate.getFullYear();
        let currentMonthIndex = selectedDate.getMonth();

        function renderCalendar(year, month) {
            const today = new Date();
            const firstDay = new Date(year, month, 1).getDay();
            const daysInMonth = new Date(year, month + 1, 0).getDate();
            const daysInPreviousMonth = new Date(year, month, 0).getDate();

            calendarDays.innerHTML = ''; // Clear previous content

            // Fill in days from the previous month
            for (let i = firstDay - 1; i >= 0; i--) {
                const day = daysInPreviousMonth - i;
                calendarDays.innerHTML += '<div class="disabled">' + day + '</div>';
            }

            // Fill in days for the current month
            for (let day = 1; day <= daysInMonth; day++) {
                const currentDate = new Date(year, month, day);
                const isDisabled = currentDate < today.setHours(0, 0, 0, 0);
                const isSelected =
                    day === selectedDate.getDate() &&
                    month === selectedDate.getMonth() &&
                    year === selectedDate.getFullYear();

                calendarDays.innerHTML +=
                    '<div class="' +
                    (isDisabled ? 'disabled' : '') +
                    ' ' +
                    (isSelected ? 'selected' : '') +
                    '" ' +
                    'onclick="' +
                    (!isDisabled ? 'selectDate(' + year + ', ' + month + ', ' + day + ')' : '') +
                    '">' +
                    day +
                    '</div>';
            }

            // Update the header
            const monthName = new Date(year, month).toLocaleString('default', { month: 'long' });
            currentMonth.textContent = monthName + ' ' + year;

            // Disable "prev" button if it’s before today
            prevMonthButton.disabled = new Date(year, month) < new Date(today.getFullYear(), today.getMonth(), 1);
        }

        function selectDate(year, month, day) {
            selectedDate = new Date(year, month, day);
            renderCalendar(year, month);
        }

        function changeMonth(direction) {
            currentMonthIndex += direction;
            if (currentMonthIndex < 0) {
                currentMonthIndex = 11;
                currentYear--;
            } else if (currentMonthIndex > 11) {
                currentMonthIndex = 0;
                currentYear++;
            }
            renderCalendar(currentYear, currentMonthIndex);
        }

        // Initialize the calendar when the DOM is ready
        document.addEventListener('DOMContentLoaded', () => {
            renderCalendar(currentYear, currentMonthIndex);
        });
    </script>
</body>
</html>
