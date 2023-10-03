<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Animal extends Model
{
    use HasFactory;
    protected $table = 'Animal';
    protected $fillable = ['especie_id', 'nome', 'raca', 'sexo', 'peso', 'nascimento'];
    protected $casts = [
        'nascimento' => 'datetime',
        'peso' => 'float',
    ];

    public function users()
    {
        return $this->belongsToMany(User::class, 'UserAnimal', 'user_id', 'animal_id')
            ->withPivot(['isDono', 'created_at', 'updated_at']);
    }
}
