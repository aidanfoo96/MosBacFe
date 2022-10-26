rule BGC_search_antismash: 
    """
        Search for BGC using antismash
    """
    output: 
        antismash_res = "../results/antismash_out/{sample}/index.html",
    input: 
        contigs = "../results/spades/{sample}_spades_assm/contigs.fasta",
    params:
        output = "../results/antismash_out/{sample}",
        cpus = config["AntiSmash"]["Threads"],
    shell:
        r"""
            antismash --cpus {params.cpus} \
            --genefinding-tool prodigal --verbose \
            --hmmdetection-strictness strict \
            {input.contigs} --output-dir {params.output} 
         """ 

