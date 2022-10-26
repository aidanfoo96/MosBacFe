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
    
    if config["MegaHitAssm"]["Activate"]: 
        final_input.extend(
            expand(
                [
                    "../results/megahit_assm/{sample}_assm/final.contigs.fa",
                    "../results/binning/metabat_out/{sample}_bins/{sample}",
                    "../results/binning/checkm_out/{sample}_checkm/lineage.ms",
                ],
                sample = samples,
            )
        )

    if config["AMRGeneFind"]["Activate"]: 
        final_input.extend(
            expand(
                [
                    "../results/abricate_out/{sample}.tab",
                ],
                sample = samples,
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
                    "../results/genome_qa/{sample}_checkm/lineage.ms",
                    "../results/spades/{sample}_spades_assm/{sample}.fasta",
                    "../results/genome_qa_summarised/checkm_qa/{sample}/{sample}_checkm_out.tsv",
                    "../results/genome_qa/1_concatenated_bin_stats.tsv",


                ],
                sample = samples,
            )
        )
    
    if config["ShovillAssm"]["Activate"]: 
        final_input.extend(
            expand(
                [
                    "../results/shovill/{sample}_shovill_assm/contigs.fa",
                ],
                sample = samples,
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