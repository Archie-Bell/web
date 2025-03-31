import { createRouter, createWebHistory } from 'vue-router';
import AdminPanel from '@/views/AdminPanelView.vue';
import MainView from '@/views/MainView.vue';
import LoginView from '@/views/LoginView.vue';
import AuthService from '@/services/AuthService';

const routes = [
    { path: '/', name: 'Archie Bell', component: MainView },
    { path: '/s/login', name: 'Archie Bell (Staff) - Login', component: LoginView },
    { 
        path: '/s/admin-panel', 
        name: 'Archie Bell (Staff)', 
        component: AdminPanel ,
        meta: { requiresAuth: true }
    },
];

const router = createRouter({
    history: createWebHistory(),
    routes
});

router.beforeEach((to, from, next) => {
    if (to.meta.requiresAuth) {
        const token = localStorage.getItem('token');
        
        if (!token) {
            return next('/s/login');
        }

        const isAuthenticated = AuthService.verifyAuthentication(token);

        if (!isAuthenticated) {
            localStorage.removeItem('token');
            return next('/s/login');
        }

        next();
    }
    else {
        next();
    }
});


export default router;