export default {
    getDate (date) {
        console.log('Date before format: ', date);
        const inputDate = new Date(date);

        console.log('Date: ', inputDate);
        
        if (isNaN(inputDate)) {
            throw new Error("Invalid date format");
        }
    
        const day = inputDate.getDate();
        const months = [
            'Jan.',
            'Feb.',
            'Mar.',
            'Apr.',
            'May',
            'Jun.',
            'Jul.',
            'Aug.',
            'Sep.',
            'Oct.',
            'Nov.',
            'Dec.'
        ];
    
        const month = months[inputDate.getMonth()];
        const year = inputDate.getFullYear();
    
        let hours = inputDate.getHours();
        const minutes = inputDate.getMinutes().toString().padStart(2, '0');
        const isPM = hours >= 12;
        hours = hours % 12 || 12;  // Convert 24-hour time to 12-hour time
    
        const timePeriod = isPM ? 'PM' : 'AM';
    
        const formattedDateTime = `${day} ${month} ${year}, ${hours}:${minutes} ${timePeriod}`;
    
        return formattedDateTime;
    }
}
