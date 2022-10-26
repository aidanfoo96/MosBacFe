rule kraken_classification: 
    """
        taxonomically classify contigs
    """
    output: 
        txt = "../results/kraken_classification_/{sample}_report.txt",
        report = "../results/kraken_classification/{sample}_kraken_report",
    input: 
        renamed_contigs = "../results/spades/{sample}_spades_assm/{sample}.fasta",
    params: 
        kraken_db = config["KrakenClassification"]["kraken_db_location"], 
        threads = config["KrakenClassification"]["Threads"], 
    shell: 
        r"""
            kraken2 -db {params.kraken_db} \
            --output {output.report} \
            --report {output.txt} \
            --threads {params.threads} \
            {input.renamed_contigs}
         """