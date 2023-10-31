export function useFormatDate() {
  return (dateString: string | Date): Date => {
    return new Date(dateString + 'Z')
  }
}

export function useFormatDateTimeLocal() {
  return (dateString: Date): string => {

    const year: number = dateString.getFullYear();
    let month: number | string = dateString.getMonth() + 1;
    if (month < 10) {
      month = '0' + month;
    }
    let day: number | string = dateString.getDate();
    if (day < 10) {
      day = '0' + day;
    }
    let hours: number | string = dateString.getHours();
    if (hours < 10) {
      hours = '0' + hours;
    }
    let minutes: number | string = dateString.getMinutes();
    if (minutes < 10) {
      minutes = '0' + minutes;
    }

    return `${year}-${month}-${day}T${hours}:${minutes}`;
  }
}