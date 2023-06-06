#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { SAMTOOLSPOSTPROCESSING_SAMTOOLSPOSTPROCESSING } from '../../../../../modules/nf-core/samtoolspostprocessing/samtoolspostprocessing/main.nf'

workflow test_samtoolspostprocessing_samtoolspostprocessing {
    
    input = [
        [ id:'test' ], // meta map
	"abc",
        file("/mnt/volume1/abc.stats", checkIfExists: true),
        file("/mnt/volume1/abc_all.sorted.flagstat", checkIfExists: true),
        file("/mnt/volume1/abc.idxstats", checkIfExists: true)
    ]

    SAMTOOLSPOSTPROCESSING_SAMTOOLSPOSTPROCESSING ( input )
}
