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
    }
}