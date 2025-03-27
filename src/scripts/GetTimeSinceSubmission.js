export default {
    getTimeSinceSubmission(date) {
        const now = new Date();
        const nowUTC = new Date(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate(), now.getUTCHours(), now.getUTCMinutes(), now.getUTCSeconds(), now.getUTCMilliseconds());
    
        const then = new Date(date);
        const differenceInSeconds = Math.floor((nowUTC - then) / 1000);
    
        if (differenceInSeconds < 60) {
        return `${differenceInSeconds} second${differenceInSeconds === 1 ? '' : 's'} ago`;
        }
        
        const differenceInMinutes = Math.floor(differenceInSeconds / 60);
        if (differenceInMinutes < 60) {
        return `${differenceInMinutes} minute${differenceInMinutes === 1 ? '' : 's'} ago`;
        }
    
        const differenceInHours = Math.floor(differenceInMinutes / 60);
        if (differenceInHours < 24) {
        return `${differenceInHours} hour${differenceInHours === 1 ? '' : 's'} ago`;
        }
    
        const differenceInDays = Math.floor(differenceInHours / 24);
        if (differenceInDays < 30) {
        return `${differenceInDays} day${differenceInDays === 1 ? '' : 's'} ago`;
        }
    
        const differenceInMonths = Math.floor(differenceInDays / 30);
        if (differenceInMonths < 12) {
        return `${differenceInMonths} month${differenceInMonths === 1 ? '' : 's'} ago`;
        }
    
        const differenceInYears = Math.floor(differenceInMonths / 12);
        return `${differenceInYears} year${differenceInYears === 1 ? '' : 's'} ago`;
    },

    formatDateOfSubmission(date) {
        const options = {
            year: 'numeric',
            month: 'short',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit',
            hour12: true,
        };
    
        let formattedDate = new Date(date).toLocaleString('en-GB', options);
    
        formattedDate = formattedDate.replace(/([ap])m/i, (match) => match.toUpperCase());
        formattedDate = formattedDate.replace(/(\w{3})(\s)/, '$1.$2');    
        formattedDate = formattedDate.replace(/(\d{2}) (\w{3}\.) (\d{4}\,),/, '$1 $2 $3');
    
        return formattedDate;
    }
}