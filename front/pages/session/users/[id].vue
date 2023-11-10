<script setup lang="ts">
import { useSessionStore } from "~/stores/sessionStore";
import type { IUser } from "~/utils/user";
import { VueChartBar } from "#components";

const route = useRoute();
const router = useRouter();
const getUserAPI = useGetUser();
const deleteUserAPI = useDeleteUser();
const formatChartData = useFormatChartDataWorkingTime();

const session = useSessionStore();
const user = ref<IUser | null>(null);
const updateUserAPI = useUpdateUser();

const chartData = computed(() => {
  if (!user.value) {
    return null;
  }
  return formatChartData([user.value], user.value?.working_times);
});

const userGeneralManager = computed(() => {
  return isUserGeneralManager(session.user as IUser);
});

const targetUserIsAdmin = computed(() => {
  if (!user.value) {
    return false;
  }

  return isUserAdmin(user.value);
});

const canDeleteUser = computed(() => {
  return (
    userGeneralManager.value &&
    !targetUserIsAdmin.value &&
    session.user?.id !== user.value?.id
  );
});

const fetchUser = async () => {
  const id = parseInt(route.params.id.toString()) ?? 0;

  const response = await getUserAPI(id);

  if (!response.ok) {
    user.value = null;
    return alert("User does not exists");
  }

  user.value = response.data;
};

const deleteUser = async () => {
  if (!user.value) {
    return;
  }

  const response = await deleteUserAPI(user.value.id);

  if (!response.ok) {
    return alert("Failed to delete user");
  }

  return navigateTo("/session/users");
};

const userFormValue = reactive({
  firstname: user.value?.firstname ?? "",
  lastname: user.value?.lastname ?? "",
  email: user.value?.email ?? "",
});

onMounted(async () => {
  await fetchUser();
  await onClockOut();

  userFormValue.firstname = user.value?.firstname ?? "";
  userFormValue.lastname = user.value?.lastname ?? "";
  userFormValue.email = user.value?.email ?? "";
});

const onSubmit = async () => {
  if (!user.value) {
    return;
  }

  const response = await updateUserAPI(user.value.id, userFormValue);

  if (!response.ok) {
    return alert("Error happened while updating user");
  }

  await fetchUser();
  userFormValue.firstname = user.value?.firstname;
  userFormValue.lastname = user.value?.lastname;
  userFormValue.email = user.value?.email;
};

const chart1 = ref<InstanceType<typeof VueChartBar> | null>();

const onClockOut = () => {
  chart1.value.reRender(() => {
    if (!user.value) {
      return;
    }
    fetchUser();
  });
};
</script>

<template>
  <section v-if="user" class="mt-0 md:mt-6 px-2 md:px-5">
    <AppButton
      button-style="secondary"
      type="button"
      class="flex items-center self-start mt-3 lg:mt-0"
      @click="router.back()"
    >
      <svg-icon name="back-arrow" class="w-3 h-3 mr-2" /> Retour
    </AppButton>
    <div class="mt-5 flex flex-col-reverse md:flex-row gap-5">
      <AppCard class="flex-grow-0 md:flex-grow">
        <UserForm
          v-model="userFormValue"
          :true-user="user"
          :readonly="!userManageable(session.user as IUser, user)"
          @submit="onSubmit"
        />
        <div>
          <span class="block font-medium">Équipes</span>
          <div
            class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-5 xl:grid-cols-7 gap-3 mt-5"
          >
            <div
              v-for="team in user.teams"
              :key="team.id"
              class="flex items-center gap-3 border border-gray-700 rounded max-w-[200px] px-4 py-2"
            >
              <svg-icon name="team" class="w-5 h-5" />
              <span
                class="font-medium text-center text-sm whitespace-nowrap text-ellipsis overflow-hidden"
                >{{ team.name }}</span
              >
            </div>
          </div>
          <div class="w-full mt-3">
            <AppButton
              v-if="canDeleteUser"
              button-style="danger"
              class="!px-5 ml-auto flex items-center"
              @click="deleteUser"
            >
              <svg-icon name="trash" class="w-5 h-5 mr-2" />Supprimer
            </AppButton>
          </div>
        </div>
      </AppCard>
      <ClockManager
        :user="user"
        :manageable="userManageable(session.user as IUser, user)"
        in-label="Badger"
        out-label="Badger"
        class="md:w-1/3"
        @clock-out="onClockOut"
      />
    </div>
    <AppCard v-if="chartData" class="h-96">
      <VueChartLine ref="chart1" :chart-data="chartData" />
    </AppCard>
  </section>
</template>

<style scoped></style>
