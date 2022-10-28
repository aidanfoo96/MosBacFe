def RunPipeLine(wildcards): 

    final_input = []

    if config["QC_Reads"]["Activate"]:
        final_input.extend(
            expand(
                [
                    "../results/qc/fastqc/{sample}_{num}.html", 
                    "../results/qc/fastqc/{sample}_{num}_fastqc.zip",
                    "../results/qc/trimmed_fastq/{sample}_trimmed_1.fastq",
                    "../results/qc/trimmed_fastq/{sample}_trimmed_2.fastq", 
                    "trimmed/{sample}.qc.txt",
                ],
                sample = samples,
                num = [1, 2], 
            )
        )

    if config["GTDBTkClassification"]["Activate"]:
        final_input.extend(
            expand(
                [
                    "../results/GTDBTk_Classification/{sample}/",
                ],
                sample = samples,
            )
        )
    
    if config["AntiSmash"]["Activate"]:
        final_input.extend(
            expand(
                [
                    "../results/antismash_out/{sample}/index.html",
                ],
                sample = samples,
            )
        )

    if config["SPAdesAssm"]["Activate"]:
        final_input.extend(
            expand(
                [
                    "../results/spades/{sample}_spades_assm/contigs.fasta",
                    "../results/spades/{sample}_spades_assm/{sample}.fasta",
                    "../results/genome_qa/1_concatenated_bin_stats.tsv",
                ],
                sample = samples,
            )
        )
    
    if config["ShovillAssm"]["Activate"]: 
        final_input.extend(
            expand(
                [
                    "../results/shovill/{sample}_shovill_assm/{sample}.{assembler}.assembly.fa",
                    "../results/genome_qa/{sample}_checkm/lineage.ms",
                    "../results/genome_qa_summarised/checkm_qa/{sample}/{sample}_checkm_out.tsv",
                ],
                sample = samples,
                assembler = "shovill",
            )
        )

    if config["fegenie"]["Activate"]: 
        final_input.extend(
            expand(
                [
                    "../results/winning_genomes/{GoodGenome}.fasta",
                    "../results/fegenie/FeGenie-summary-blasthits.csv",

                ],
                GoodGenome = GoodGenomes,
            )
        )

    if config["KrakenClassification"]["Activate"]: 
        final_input.extend(
            expand(
                [
                    "../results/kraken_classification_/{sample}_report.txt",
                ],
                sample = samples,

            )
        )
                
    return(final_input)