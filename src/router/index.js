import { createRouter, createWebHistory } from 'vue-router';
import AdminPanel from '@/views/AdminPanel.vue';
import MainView from '@/views/MainView.vue';

const routes = [
    { path: '/', name: 'Archie Bell', component: MainView },
    { path: '/s/admin-panel', name: 'Archie Bell (Staff)', component: AdminPanel },

    {

    }
];

const router = createRouter({
    history: createWebHistory(),
    routes
});

export default router;