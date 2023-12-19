nextflow.enable.dsl=2


include { CONCATMITO_CONCATMITO } from './modules/nf-core/concatmito/concatmito/'
include { MINIMAP2_INDEX } from './modules/nf-core/minimap2/index/'
include { MINIMAP2_ALIGN } from './modules/nf-core/minimap2/align/'
include { SAMTOOLS_SORT as SAMTOOLS_SORT } from './modules/nf-core/samtools/sort/'
include { SAMTOOLS_VIEW } from './modules/nf-core/samtools/view/'
include { SAMTOOLS_SORT as SAMTOOLS_SORT2 } from './modules/nf-core/samtools/sort/'
include { SAMTOOLS_STATS } from './modules/nf-core/samtools/stats/'
include { SAMTOOLS_FLAGSTAT } from './modules/nf-core/samtools/flagstat/'
include { SAMTOOLS_INDEX } from './modules/nf-core/samtools/index/'
include { SAMTOOLS_IDXSTATS } from './modules/nf-core/samtools/idxstats/'
include { SAMTOOLSPOSTPROCESSING_SAMTOOLSPOSTPROCESSING } from './modules/nf-core/samtoolspostprocessing/samtoolspostprocessing/'
include { SAMTOOLSALL_SAMTOOLSALL } from './modules/nf-core/samtoolsall/samtoolsall/'
include { HISTOGRAM_HISTOGRAM } from './modules/nf-core/histogram/histogram/'


ch_reads = Channel
                .fromFilePairs( params.reads)
                .map {  item ->
                        sampleName = item[0];
                        files  = item[1];
                        return sampleName  }

ch_reads_2 = Channel
                .fromFilePairs( params.reads  )
                .map {  item ->
                        sampleName = item[0];
                        files  = item[1];
                        return [[ id: sampleName ], files ] }
			
workflow {

      ch_reference = CONCATMITO_CONCATMITO([[ id: ch_reads ],"/mnt/volume1/mito.fasta"]).fa
      ch_refref = ch_reference.map { meta, ref -> return ref }
      ch_indexed_ref = MINIMAP2_INDEX(ch_reference).index
    
      ch_align = MINIMAP2_ALIGN(ch_reads_2,ch_refref,"true","false","false").bam
      ch_sort = SAMTOOLS_SORT(ch_align).bam
      ch_sortsort = ch_sort.map { meta , bambam -> return [meta,bambam,"/mnt/volume/mito.fasta"] }
      ch_viewview = SAMTOOLS_VIEW(ch_sortsort,ch_refref,[]).bam
      
      ch_sort2 = SAMTOOLS_SORT2(ch_viewview).bam
      ch_inputindex = ch_sort.map { meta, bambam -> return [ meta , bambam , "/mnt/volume/mito.fasta" ] }
      ch_stats = SAMTOOLS_STATS(ch_inputindex,ch_refref).stats
      ch_statsstats = ch_stats.map { meta, stats -> return stats }
      ch_inputindex2 = ch_sort2.map { meta, bambam -> return [ meta , bambam , "/mnt/volume/mito.fasta" ] }
      ch_flagstat = SAMTOOLS_FLAGSTAT(ch_inputindex2).flagstat
      ch_flagstatflagstat = ch_flagstat.map { meta, flag -> return flag }
      SAMTOOLS_INDEX(ch_sort2)
      ch_idxstats = SAMTOOLS_IDXSTATS(ch_inputindex2).idxstats
      ch_idxstatsidxstats = ch_idxstats.map { meta, idx -> return idx }

      SAMTOOLSPOSTPROCESSING_SAMTOOLSPOSTPROCESSING(ch_stats.join(ch_flagstat).join(ch_idxstats))
      ch_samall = SAMTOOLSALL_SAMTOOLSALL(ch_sort.join(ch_sort2)).txt
      ch_samall.view()
      HISTOGRAM_HISTOGRAM(ch_samall)

}


