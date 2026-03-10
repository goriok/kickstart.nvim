// $MODULE_NAME_test.go
// Test: $DESCRIPTION

package $PACKAGE

import "testing"

func Test$FunctionName(t *testing.T) {
	tests := []struct {
		name     string
		input    string
		expected string
		wantErr  bool
	}{
		{
			name:     "valid input",
			input:    "$INPUT",
			expected: "$EXPECTED",
			wantErr:  false,
		},
		{
			name:    "empty input",
			input:   "",
			wantErr: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := $FunctionName(tt.input)
			if (err != nil) != tt.wantErr {
				t.Errorf("$FunctionName() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !tt.wantErr && got != tt.expected {
				t.Errorf("$FunctionName() = %v, want %v", got, tt.expected)
			}
		})
	}
}
