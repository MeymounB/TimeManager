export function useFormatDate() {
  return (dateString: string | Date): Date => {
    return new Date(dateString + 'Z')
  }
}