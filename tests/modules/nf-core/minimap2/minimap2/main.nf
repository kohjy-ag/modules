#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { MINIMAP2_MINIMAP2 } from '../../../../../modules/nf-core/minimap2/minimap2/main.nf'

workflow test_minimap2_minimap2 {
    
    input = [
        [ id:'test'], // meta map
        file("/home/ubuntu/reference_database.fa", checkIfExists: true)
    ]

    MINIMAP2_MINIMAP2 ( input )
}
