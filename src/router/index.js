import Vue from 'vue'
import Router from 'vue-router'
import Roulette from '@/components/roulette'
import BootstrapVue from 'bootstrap-vue'
import jQuery from 'jquery/jquery'
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'
import 'font-awesome/css/font-awesome.css'

Vue.use(Router)
Vue.use(BootstrapVue)
Vue.use(jQuery)
export default new Router({
  routes: [
    {
      path: '/',
      name: 'roulette',
      component: Roulette
    }
  ]
})
