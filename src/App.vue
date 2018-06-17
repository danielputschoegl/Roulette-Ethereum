<template>
    <div id="app" style="margin-top: 0; background-color: lightgreen">
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
        border-color: lightgreen !important;
        border: 1px;
    }
</style>
