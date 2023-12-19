#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { SAMTOOLSALL_SAMTOOLSALL } from '../../../../../modules/nf-core/samtoolsall/samtoolsall/main.nf'

workflow test_samtoolsall_samtoolsall {
    
    input = [
        [ id:'test', single_end:false ], // meta map
        file(params.test_data['sarscov2']['illumina']['test_paired_end_bam'], checkIfExists: true)
    ]

    SAMTOOLSALL_SAMTOOLSALL ( input )
}
