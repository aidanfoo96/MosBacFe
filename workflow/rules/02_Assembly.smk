



#-------------------------------------------------------------------#
rule spades_assm:
    """
        Run a SPAdes assembly on trimmed fastq reads
    """
    output: 
        assm = "../results/spades/{sample}_spades_assm/contigs.fasta",
    input: 
        read1 = "../results/qc/trimmed_fastq/{sample}_trimmed_1.fastq",
        read2 = "../results/qc/trimmed_fastq/{sample}_trimmed_2.fastq", 
    params: 
        threads = config["SPAdesAssm"]["Threads"], 
        outputdir = "../results/spades/{sample}_spades_assm/",
    shell: 
        r"""
            spades -1 {input.read1} \
            -2 {input.read2} \
            -o {params.outputdir} \
            -t {params.threads}
         """


#-------------------------------------------------------------------#
rule shovil_assm: 
    """
        Run assembly using shovill
    """
    output: 
        assm = "../results/shovill/{sample}_shovill_assm/{sample}.{assembler}.assembly.fa",
        contigs = "../results/shovill/{sample}_shovill_assm/{sample}.{assembler}.contigs.fa",
    input: 
        read1 = "../results/qc/trimmed_fastq/{sample}_trimmed_1.fastq",
        read2 = "../results/qc/trimmed_fastq/{sample}_trimmed_2.fastq", 
    params:
        extra = ""
    log: 
        "logs/shovill/{sample}.{assembler}.log",
    threads: 
        threads = config["ShovillAssm"]["Threads"],
    wrapper: 
        "v1.18.0/bio/shovill"


#-------------------------------------------------------------------#
rule rename_contigs: 
    """
        Rename spades contigs from 'contigs.fasta' to something more meaningful
    """  
    output: 
        renamed_contigs = "../results/spades/{sample}_spades_assm/{sample}.fasta",
    input:
        assm = "../results/spades/{sample}_spades_assm/contigs.fasta",
    shell: 
        r"""
            cp {input.assm} {output.renamed_contigs}
         """


#-------------------------------------------------------------------#
rule checkM_genome: 
    """
        Check genome completeness and contamination
    """
    output: 
        checkm_out = "../results/genome_qa/{sample}_checkm/lineage.ms",
    input: 
        assm = expand("../results/shovill/{sample}_shovill_assm/{sample}.{assembler}.assembly.fa", assembler = "shovill", sample = samples),
    params: 
        outdir = "../results/genome_qa/{sample}_checkm/",
        indir = "../results/spades/{sample}_spades_assm/",
        threads = config["SPAdesAssm"]["CheckmThreads"],
    shell: 
        r"""
            checkm lineage_wf -t {params.threads} \
            --pplacer_threads {params.threads} \
            -x contigs.fasta {params.indir} {params.outdir} 
         """


#-------------------------------------------------------------------#
rule QA_checkm:
    """
        Do QA from CheckM to generate a specific .tsv summary file
    """
    output: 
        qa_checkm = "../results/genome_qa_summarised/checkm_qa/{sample}/{sample}_checkm_out.tsv",
    input:
        checkm_out = "../results/genome_qa/{sample}_checkm/lineage.ms",
    params: 
        direc = "../results/genome_qa/{sample}_checkm/"
    shell: 
        r"""
            checkm qa -f {output.qa_checkm} --tab_table -o 2 \
            {input.checkm_out} {params.direc}
         """


#-------------------------------------------------------------------#
rule concatenate_checkM:
    """
        Concatenate quality checked files from each genome 
    """
    output: 
        concat = "../results/genome_qa/1_concatenated_bin_stats.tsv",
    input: 
        sample = expand("../results/genome_qa_summarised/checkm_qa/{sample}/{sample}_checkm_out.tsv", sample = samples),
    params: 
        filename = "FILENAME",
    shell: 
        r"""
            awk '{{print $0 "\t" {params.filename}}}' {input.sample} > {output.concat}
         """


#-------------------------------------------------------------------#
rule filter_winning_bins: 
    """
        R script to make a tsv file of ''winning'' bins
        With completeness and contamination threshold
    """

