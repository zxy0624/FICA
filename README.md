# FICA

This project, written in MATLAB, aims to assist a gas manufacturing and processing plant in Henan, China, with optimization scheduling. The problem itself is complex, as gas processing involves various manufacturing issues such as flexible manufacturing, batch manufacturing, parallel machine manufacturing, and open manufacturing. Research on production scheduling for highly personalized workshops is still limited. Therefore, studying the workshop scheduling problem in the standard gas manufacturing industry is of great practical significance for improving production efficiency, reducing energy consumption, and meeting diverse customer demands.

## Project Background

1. **Complexity of the Problem**: Gas processing involves a combination of multiple manufacturing issues.
2. **Mathematical Modeling**: Attempts to comprehensively reflect the problem itself, including processing loss, transportation loss, machine operations in batch manufacturing, etc. Due to the lack of existing datasets, sampling in actual factories is required to organize data for optimization.
3. **Algorithm Selection**: Conventional algorithms (such as genetic algorithms, simulated annealing algorithms) are less effective. Based on the Imperialist Competitive Algorithm (ICA), a deep Federal Competitive Algorithm (FICA) is created to solve the problem.

## Algorithm Structure

The algorithm is divided into two layers:
- **Inner Layer**: Located in the `formula` folder, run the `main` function directly.
- **Outer Layer**: The main function is `FICAmain`, which is also run directly.

## Usage

1. Add the project folder to the MATLAB path.
2. Run the `FICAmain` function to start the optimization scheduling.

## License

This project is licensed under the MIT License. For more details, please refer to the LICENSE file.

---
