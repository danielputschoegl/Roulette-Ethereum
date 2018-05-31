<template>
    <div id="app">
        <router-view/>
    </div>
</template>

<script>
    export default {
        name: 'App'
    }
</script>

<style>
    #app {
        font-family: 'Avenir', Helvetica, Arial, sans-serif;
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
        text-align: center;
        color: #2c3e50;
        margin-top: 60px;
        align-items: center;
    }

    button {
        width: 5em;
        height: 5em;
    }

    .active {
        -webkit-transform: rotate(1000000000000000000000000000deg);
        -webkit-transition: -webkit-transform 1000000000000000000s ease-out;
    }

    .fadeOut {
        -webkit-transform: rotate(600deg);
        -webkit-transition: -webkit-transform 2s ease-out;
    }
</style>
