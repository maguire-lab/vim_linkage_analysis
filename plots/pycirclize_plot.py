from pycirclize import Circos
from pycirclize.utils import fetch_genbank_by_accid
from pycirclize.parser import Genbank
from Bio.SeqFeature import SeqFeature, FeatureLocation

import matplotlib.pyplot as plt

def plot_plasmid(gbk, name, color, integron_coords, large=False):
    # Initialize Circos instance with genome size
    if large:
        fig = plt.figure(figsize=(6, 6), dpi=600)
        polar_ax1 = fig.add_subplot(111, polar=True)
    else:
        fig = plt.figure(figsize=(6, 6), dpi=600)
        polar_ax1 = fig.add_subplot(111, polar=True)


    circos = Circos(sectors={gbk.name: gbk.range_size})
    circos.text(f"{gbk.name}", size=14)
    circos.rect(r_lim=(94, 95), fc="black", ec="none", alpha=1)
    sector = circos.sectors[0]

    integron_track = sector.add_track((80, 84))
    integron_feat = [SeqFeature(FeatureLocation(*x), type='domain') for x in integron_coords]
    integron_track.genomic_features(integron_feat, plotstyle='box', fc='grey', lw=1.0)

    # Plot CDS
    cds_track = sector.add_track((90, 100))
    cds_feats = gbk.extract_features("CDS")
    cds_track.genomic_features(cds_feats, plotstyle="arrow", fc=color, lw=1.0)

    # Plot VIM
    vim_feat = []
    for feat in cds_feats:
        if "VIM" in feat.qualifiers['product'][0]:
            vim_feat.append(feat)
    cds_track.genomic_features(vim_feat, plotstyle="arrow", fc="#d95f02ff", lw=1.0)

    # Plot 'gene' qualifier label if exists
    labels, label_pos_list = [], []
    for feat in gbk.extract_features("CDS"):
        start = int(str(feat.location.start))
        end = int(str(feat.location.end))
        label_pos = (start + end) / 2
        gene_name = feat.qualifiers.get("gene", [None])[0]
        if gene_name is not None:
            labels.append(gene_name)
            label_pos_list.append(label_pos)

    cds_track.xticks(label_pos_list, labels, label_size=10, label_orientation="vertical")

    # Plot xticks (interval = 10 Kb)
    if large:
        cds_track.xticks_by_interval(
            50000, outer=False, label_formatter=lambda v: f"{v/1000:.1f} Kb"
        )
    else:
        cds_track.xticks_by_interval(
            10000, outer=False, label_formatter=lambda v: f"{v/1000:.1f} Kb"
        )
    fig = circos.plotfig(ax=polar_ax1)
    fig.savefig(f"{name.replace(' ', '_')}.png", dpi=300)
    fig.savefig(f"{name.replace(' ', '_')}.svg")


if __name__ == "__main__":
    with open('../vim_plasmids/bakta/pputida_trycycler_vim_plasmid_ac907/pputida_trycycler_vim_plasmid_ac907.gbff') as fh:
        pputida_gbk = Genbank(fh)
        plot_plasmid(pputida_gbk, "Pseudomonas", "#66a61eff", [(147217, 151320)], large=True)
    with open('../vim_plasmids/bakta/enterobacter_unicycler_vim_plasmid_aa919/enterobacter_unicycler_vim_plasmid_aa919.gbff') as fh:
        enterobacter_gbk = Genbank(fh)
        plot_plasmid(enterobacter_gbk, "Enterobacter", "#1b9e77ff", [(52156, 57165)])
    with open('../vim_plasmids/bakta/proteus_unicycler_vim_plasmid_ac082/proteus_unicycler_vim_plasmid_ac082.gbff') as fh:
        proteus_gbk = Genbank(fh)
        plot_plasmid(proteus_gbk, "Proteus", "#7570b3ff", [(21986, 24508), (10303, 15337)])


