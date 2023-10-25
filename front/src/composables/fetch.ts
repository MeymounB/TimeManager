export async function useFetch<T>(method: 'GET' | 'POST' | 'PUT' | 'DELETE', url: string, body?: any): Promise<T | null> {
	const response= await fetch(url, {headers: { 'Content-type': 'application/json'}, method, body})

	if (!response.ok) {
		return null
	}
	const { data } = await response.json()
	return data
}
