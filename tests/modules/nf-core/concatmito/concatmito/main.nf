#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { CONCATMITO_CONCATMITO } from '../../../../../modules/nf-core/concatmito/concatmito/main.nf'

workflow test_concatmito_concatmito {
    
    input = [
        [ id:'test' ], // meta map
        file("/mnt/sdd/reference_genome/GRCh38.p13.genome.fa", checkIfExists: true)
    ]

    CONCATMITO_CONCATMITO ( input )
}
