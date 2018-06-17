<template>
    <div>
        <roulette-component/>
        <!--<hello-metamask/>-->
    </div>
</template>
<script>
    import HelloMetamask from '@/components/hello-metamask'
    import RouletteComponent from '@/components/roulette-component'

    export default {
        name: 'roulette',
        beforeCreate() {
            console.log('registerWeb3 Action dispatched from roulette.vue')
            this.$store.dispatch('registerWeb3')
        },
        components: {
            'hello-metamask': HelloMetamask,
            'roulette-component': RouletteComponent
        }
    }
</script>
<style scoped>
</style>
