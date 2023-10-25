import { defineStore } from 'pinia'
import { StorageSerializers, useLocalStorage } from '@vueuse/core';
import type { IUser, IUserDTO } from '@/types/user';
import { useFetch } from '@/composables/fetch';
import { useGetUser } from '@/composables/user';

export const useSessionStore = defineStore('counter', () => {
  const user = useLocalStorage<IUser | null>('user', null, {
    serializer: StorageSerializers.object,
  })

  async function reloadUser() {
    if (!user.value) {
      return
    }
    user.value = await useGetUser()(user.value.id)
  }

  setTimeout( () => {
    reloadUser().catch(err => console.error(err))
  }, 0)

  return { user }
})
