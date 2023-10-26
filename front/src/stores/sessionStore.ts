import { defineStore } from 'pinia'
import { StorageSerializers, useLocalStorage } from '@vueuse/core';
import type { IUser } from '@/types/user';
import { useGetUser } from '@/composables/user';

export const useSessionStore = defineStore('counter', () => {
  const user = useLocalStorage<IUser | null>('user', null, {
    serializer: StorageSerializers.object,
  })

  async function reloadUser() {
    if (!user.value) {
      return
    }
    const response = await useGetUser()(user.value.id)

    if (!response.ok) {
      return
    }

    user.value = response.data
  }

  function localLogout() {
    if (!user.value) {
      return
    }

    user.value = null
  }

  setTimeout( () => {
    reloadUser().catch(err => console.error(err))
  }, 0)

  return { user, localLogout }
})
