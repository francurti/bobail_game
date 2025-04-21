const int bobailPosition = 12;
const Set<int> whitePositions = {0, 1, 2, 3, 4};
const Set<int> blackPositions = {20, 21, 22, 23, 24};
const int rowsInBoard = 5;

bool whiteWon(int bobailPosition) => bobailPosition < 5;
bool blackWon(int bobailPosition) => bobailPosition >= 20;
