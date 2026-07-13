# 🚀 Edge Analytics IP Core

Welcome to the **Edge Analytics IP Core** project!  
This repository contains RTL design files, OpenLane configuration, and sign‑off results for implementing a custom ASIC design flow.

---

## ✨ Features
- 📂 Modular RTL design (`src/` folder)
- ⚙️ OpenLane flow setup (`config.tcl`)
- 🏗️ Floorplan, PDN, and routing outputs (`runs/`)
- 📜 Documentation and requirements (`README.md`, `requirements.txt`)

---

## 📦 Prerequisites
Before running the flow, make sure you have:
- 🐧 **Ubuntu/Linux environment**
- 🐳 **Docker installed** (for OpenLane)
- 🛠️ **Git** for version control
- 📦 Required Python packages (see `requirements.txt`)

Install dependencies:
```bash
pip install -r requirements.txt
```

## 🛠️ Steps to Implement
1. Clone the repository
bash
git clone https://github.com/sharavana864/Edge_Analytics_IP_Core.git
cd Edge_Analytics_IP_Core
2. Set up OpenLane
bash
git clone https://github.com/The-OpenROAD-Project/OpenLane.git
cd OpenLane
make pull-openlane
3. Prepare the design
Place RTL files in src/

Configure design parameters in config.tcl

4. Run the flow
bash
./flow.tcl -design Edge_Analytics_IP_Core
5. Check results
Layouts (.gds, .lef) in runs/

Timing reports and DRC/LVS checks

## 📊 Repository Structure
#Edge_Analytics_IP_Core/
├── src/                  # RTL Verilog source files
├── runs/                 # OpenLane run outputs
├── config.tcl            # Design configuration
├── requirements.txt      # Python dependencies
└── README.md             # Project documentation
## 🎯 Goals
This project demonstrates:

ASIC design flow using OpenLane

Edge analytics logic implementation in hardware

End‑to‑end chip design from RTL → GDSII

## 🤝 Contributing
Pull requests are welcome!
For major changes, please open an issue first to discuss what you’d like to change.
