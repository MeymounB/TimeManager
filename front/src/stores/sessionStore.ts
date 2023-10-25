import { defineStore } from 'pinia'
import { StorageSerializers, useLocalStorage } from '@vueuse/core';
import type { IUser } from '@/types/user';
import { useGetUser } from '@/composables/user';

export const useSessionStore = defineStore('counter', () => {
  const user = useLocalStorage<IUser | null>('user', null, {
    serializer: StorageSerializers.object,
  })

  async function reloadUser() {
    const response = await useGetUser()(2)

    if (!response.ok) {
      return
    }

    user.value = response.data
  }

  setTimeout( () => {
    reloadUser().catch(err => console.error(err))
  }, 0)

  return { user }
})
