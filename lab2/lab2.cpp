int main()
{

	int arr[16] = { 8, 7, 3, 1, 5, 4, 1, 1, 1, 0, 7, 1, 1, 8, 1, 5 };

	int size = 4;

	int diagsNum = (size - 2) * 2;

	for (int i = 1; i < size - 1; i++) {
		int right = i + i * (size - 1);
		int left = i;
		int control = i;
		do {
			for (int j = left; j < right; j += size - 1) {
				if (arr[j] > arr[j + size - 1]) {
					int buf = arr[j];
					arr[j] = arr[j + size - 1];
					arr[j + size - 1] = buf;
					control = j;
				}
			}
			right = control;
			for (int j = right; j > left; j -= size - 1) {
				if (arr[j] < arr[j - size + 1]) {
					int buf = arr[j];
					arr[j] = arr[j - size + 1];
					arr[j - size + 1] = buf;
					control = j;
				}
			}
			left = control;
		} while (left < right);
	}


	for (int i = 1; i < size - 1; i++) {
		int left = size*size - i - 1 - i*(size - 1);
		int right = size*size - i - 1;
		int control = size * size - i - i * (size - 1);
		do {
			for (int j = left; j < right; j += size - 1) {
				if (arr[j] < arr[j + size - 1]) {
					int buf = arr[j];
					arr[j] = arr[j + size - 1];
					arr[j + size - 1] = buf;
					control = j;
				}
			}
			right = control;
			for (int j = right; j > left; j -= size - 1) {
				if (arr[j] > arr[j - size + 1]) {
					int buf = arr[j];
					arr[j] = arr[j - size + 1];
					arr[j - size + 1] = buf;
					control = j;
				}
			}
			left = control;
		} while (left > right);
	}

	return 0;
}
